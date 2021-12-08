{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.script;

{$i simba.inc}
{$IFDEF DARWIN}
  {$modeswitch objectivec1}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  lptypes, lpvartypes, lpcompiler, lpparser, lpinterpreter, lpmessages,
  simba.script_compiler, simba.script_communication, simba.script_debugger, simba.client;

type
  TSimbaScript = class(TThread)
  protected
    FState: TInitBool;
    FTarget: String;
    FStartTime: UInt64;

    FScriptFile: String;
    FScriptName: String;

    FCompiler: TSimbaScript_Compiler;
    FCompileOnly: Boolean;

    FClient: TClient;
    FSimbaCommunicationServer: String;
    FSimbaCommunication: TSimbaCommunicationClient;

    FTerminated: Boolean;
    FUserTerminated: Boolean;
    FDebugging: Boolean;
    FDebugger: TSimbaScript_Debugger;

    procedure Execute; override;

    procedure HandleTerminate(Sender: TObject);
    procedure HandleException(E: Exception);
    procedure HandleStateThread;
    procedure HandleHint(Sender: TLapeCompilerBase; Hint: lpString);
    function HandleFindFile(Sender: TLapeCompiler; var FileName: lpString): TLapeTokenizerBase;
    function HandleDirective(Sender: TLapeCompiler; Directive, Argument: lpString; InPeek, InIgnore: Boolean): Boolean;

    procedure SetState(Value: TInitBool);
  public
    property Terminated: Boolean read FTerminated;
    property UserTerminated: Boolean read FUserTerminated;

    property Compiler: TSimbaScript_Compiler read FCompiler;
    property CompileOnly: Boolean read FCompileOnly write FCompileOnly;

    property SimbaCommunicationServer: String read FSimbaCommunicationServer write FSimbaCommunicationServer;

    property Client: TClient read FClient;
    property State: TInitBool read FState write SetState;
    property StartTime: UInt64 read FStartTime;
    property Target: String read FTarget write FTarget;
    property Debugging: Boolean read FDebugging write FDebugging;

    property ScriptFile: String read FScriptFile write FScriptFile;
    property ScriptName: String read FScriptName write FScriptName;

    procedure Invoke(Method: TSimbaMethod; DoFree: Boolean = False);

    constructor Create; reintroduce;
  end;

var
  SimbaScript: TSimbaScript;

implementation

uses
  {$IFDEF DARWIN}
  cocoaall, cocoaint, cocoautils,
  {$ENDIF}
  fileutil, forms, lazloggerbase,
  simba.files, simba.datetime, simba.script_plugin, simba.script_compiler_onterminate;

procedure TSimbaScript.HandleHint(Sender: TLapeCompilerBase; Hint: lpString);
begin
  DebugLn(Hint);
end;

procedure TSimbaScript.HandleException(E: Exception);
begin
  if (TextRec(Output).Mode <> fmClosed) then
    WriteLn(E.Message);

  if (FSimbaCommunication <> nil) then
  begin
    if (E is lpException) then
      with E as lpException do
        Self.Invoke(TSimbaMethod_ScriptError.Create(DocPos.Line, DocPos.Col, DocPos.FileName), True);
  end else
    ExitCode := 1;
end;

function TSimbaScript.HandleFindFile(Sender: TLapeCompiler; var FileName: lpString): TLapeTokenizerBase;
begin
  Result := nil;
  if (not FindFile(FileName, '', [IncludeTrailingPathDelimiter(ExtractFileDir(Sender.Tokenizer.FileName)), GetIncludePath(), GetSimbaPath()])) then
    FileName := '';
end;

function TSimbaScript.HandleDirective(Sender: TLapeCompiler; Directive, Argument: lpString; InPeek, InIgnore: Boolean): Boolean;
var
  Plugin: TSimbaScriptPlugin;
  CurrentDirectory, FileName: String;
begin
  Result := Directive.ToUpper().IndexOfAny(['ERROR', 'LOADLIB', 'LIBPATH', 'IFHASLIB', 'IFHASFILE', 'INCLUDE_ALL']) > -1;

  if Result then
  try
    if InIgnore or InPeek or (Argument = '') then
      Exit;

    if FileExists(Sender.Tokenizer.FileName) then
      CurrentDirectory := ExtractFileDir(Sender.Tokenizer.FileName)
    else
      CurrentDirectory := '';

    case Directive.ToUpper() of
      'INCLUDE_ALL':
        begin
          for FileName in FindFiles([CurrentDirectory, GetIncludePath(), GetSimbaPath()], Argument) do // {$include_all foo/*.pas;*.foo}
            FCompiler.HandleDirective(FCompiler.Tokenizer, 'include', FileName);
        end;

      'LOADLIB':
        begin
          if not FindPlugin(Argument, [CurrentDirectory, GetPluginPath(), GetSimbaPath()]) then
            raise Exception.Create('Plugin "' + Argument + '" not found');

          Plugin := TSimbaScriptPlugin.Create(Argument);
          Plugin.Import(FCompiler);
        end;

      'LIBPATH':
        begin
          if not FindPlugin(Argument, [CurrentDirectory, GetPluginPath(), GetSimbaPath()]) then
            Argument := '';

          FCompiler.pushTokenizer(TLapeTokenizerString.Create(#39 + Argument + #39));
        end;

      'IFHASLIB':
        begin
          if not FindPlugin(Argument, [CurrentDirectory, GetPluginPath(), GetSimbaPath()]) then
            FCompiler.pushConditional((not InIgnore) and True, Sender.DocPos)
          else
            FCompiler.pushConditional((not InIgnore) and False, Sender.DocPos);
        end;

      'IFHASFILE':
        begin
          FCompiler.pushConditional((not InIgnore) and FindFile(Argument, '', [CurrentDirectory, GetIncludePath(), GetSimbaPath()]), Sender.DocPos);
        end;

      'ERROR':
        begin
          raise Exception.Create('User defined error: "' + Argument + '"');
        end;
    end;
  except
    on E: Exception do
      raise lpException.Create(E.Message, Sender.DocPos);
  end;
end;

procedure TSimbaScript.HandleTerminate(Sender: TObject);
begin
  if (FatalException is Exception) then
    DebugLn('Note: Script thread did not exit cleanly: ', Exception(FatalException).Message);

  {$IFDEF WINDOWS}
  if (StartupConsoleMode <> 0) then
  begin
    DebugLn('Press enter to exit');

    ReadLn();
  end;
  {$ENDIF}

  Application.Terminate();
  while not Application.Terminated do
    Application.ProcessMessages();

  {$IFDEF DARWIN}
  // https://gitlab.com/freepascal.org/lazarus/lazarus/-/issues/39496
  NSApplication.sharedApplication.postEvent_AtStart(
    nsEvent.otherEventWithType_location_modifierFlags_timestamp_windowNumber_context_subtype_data1_data2(
      NSApplicationDefined, GetNSPoint(0, 0), 0, NSTimeIntervalSince1970, 0, nil, 0, 0, 0
    ),
    True
  );
  {$ENDIF}
end;

procedure TSimbaScript.Execute;
begin
  TThread.ExecuteInThread(@HandleStateThread);

  try
    if (FSimbaCommunicationServer <> '') then
      FSimbaCommunication := TSimbaCommunicationClient.Create(FSimbaCommunicationServer);

    FClient := TClient.Create(GetPluginPath());
    FClient.MOCR.FontPath := GetFontPath();
    if StrToInt64Def(Target, 0) <> 0 then
      FClient.IOManager.SetTarget(StrToInt64Def(Target, 0));

    FCompiler := TSimbaScript_Compiler.Create(TLapeTokenizerFile.Create(FScriptFile));
    if (FScriptName <> '') then
    begin
      FCompiler.Tokenizer.FileName := FScriptName;
      if (ExtractFileExt(FScriptFile) = '.tmp') and FileIsInDirectory(FScriptFile, GetDataPath()) then
        DeleteFile(FScriptFile);
    end;

    FCompiler.OnFindFile := @HandleFindFile;
    FCompiler.OnHint := @HandleHint;
    FCompiler.OnHandleDirective := @HandleDirective;

    FCompiler.Import();

    if (FSimbaCommunicationServer = '') then
      FCompiler.addBaseDefine('SIMBAHEADLESS');

    PClient(FCompiler['Client'].Ptr)^ := FClient;
    PString(FCompiler['ScriptFile'].Ptr)^ := FScriptFile;

    if FDebugging then
      FDebugger := TSimbaScript_Debugger.Create(Self);

    FStartTime := GetTickCount64();

    if FCompiler.Compile() then
    begin
      DebugLn(Format('Succesfully compiled in %d milliseconds.', [GetTickCount64() - FStartTime]));
      if FCompileOnly then
        Exit;

      FStartTime := GetTickCount64();

      try
        if FDebugging then
          FDebugger.Start();

        RunCode(FCompiler.Emitter.Code, FCompiler.Emitter.CodeLen, FState);

        if FDebugging then
        begin
          FDebugger.Terminate();
          FDebugger.WaitFor();
        end;
      finally
        FTerminated := True;

        CallOnTerminateMethods(FCompiler);
      end;

      if (GetTickCount64() - FStartTime < 10000) then
        DebugLn(Format('Succesfully executed in %d milliseconds.', [GetTickCount64() - FStartTime]))
      else
        DebugLn(Format('Succesfully executed in %s.', [TimeStamp(GetTickCount64() - FStartTime)]));
    end;
  except
    on E: Exception do
      HandleException(E);
  end;

  if (FSimbaCommunication <> nil) then
    FreeAndNil(FSimbaCommunication);
  if (FDebugger <> nil) then
    FreeAndNil(FDebugger);
  if (FClient <> nil) then
    FreeAndNil(FClient);
  if (FCompiler <> nil) then
    FreeAndNil(FCompiler);
end;

procedure TSimbaScript.HandleStateThread;
var
  Stream: THandleStream;
  Value: UInt8;
begin
  Stream := THandleStream.Create(StdInputHandle);
  while Stream.Read(Value, SizeOf(Int32)) = SizeOf(Int32) do
  begin
    Self.State := TInitBool(Value);
    if Self.State = bFalse then
      FUserTerminated := True;
  end;

  Stream.Free();
end;

procedure TSimbaScript.SetState(Value: TInitBool);
begin
  FState := Value;

  if (FSimbaCommunication <> nil) then
    FSimbaCommunication.Invoke(TSimbaMethod_ScriptStateChanged.Create(Ord(FState)));
end;

procedure TSimbaScript.Invoke(Method: TSimbaMethod; DoFree: Boolean);
begin
  try
    if (FSimbaCommunication = nil) then
      raise Exception.Create(Method.ClassName + ' not available when running headless');

    FSimbaCommunication.Invoke(Method);
  finally
    if DoFree then
      Method.Free();
  end;
end;

constructor TSimbaScript.Create;
begin
  inherited Create(True);

  FreeOnTerminate := True;
  OnTerminate := @HandleTerminate;

  FState := bTrue;
end;

end.


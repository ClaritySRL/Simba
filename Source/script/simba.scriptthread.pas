{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.scriptthread;

{$i simba.inc}

{$IFDEF DARWIN}
  {$DEFINE COCOA_TERMINATE_FIX} // https://gitlab.com/freepascal.org/lazarus/lazarus/-/issues/39496
  {$MODESWITCH OBJECTIVEC1}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  lptypes, lpvartypes, lpmessages,
  simba.script, simba.mufasatypes;

type
  TSimbaScriptRunner = class(TThread)
  protected
    FScript: TSimbaScript;
    FCompileOnly: Boolean;

    procedure DoDebugLn(Flags: EDebugLnFlags; Text: String);
    procedure DoCompilerHint(Sender: TLapeCompilerBase; Hint: lpString);

    procedure DoTerm(Sender: TObject);
    procedure DoInputThread;
    procedure DoError(E: Exception);

    procedure Execute; override;
  public
    property Script: TSimbaScript read FScript;

    constructor Create(FileName: String;
      SimbaCommunication, TargetWindow: String;
      CompileOnly: Boolean
    ); reintroduce;
  end;


implementation

uses
  {$IFDEF COCOA_TERMINATE_FIX}
  cocoaall, cocoaint, cocoautils,
  {$ENDIF}
  Forms, FileUtil,
  simba.env, simba.files, simba.datetime, simba.script_communication;

procedure TSimbaScriptRunner.DoDebugLn(Flags: EDebugLnFlags; Text: String);
begin
  if (SimbaProcessType = ESimbaProcessType.SCRIPT_WITH_COMMUNICATION) then // Only add flags if we have communication with simba to use them
    SimbaDebugLn(Flags, Text)
  else
  begin
    if Application.HasOption('silent') and (Flags * [EDebugLn.YELLOW, EDebugLn.GREEN] <> []) then
      Exit;

    DebugLn(Text);
  end;
end;

procedure TSimbaScriptRunner.DoCompilerHint(Sender: TLapeCompilerBase; Hint: lpString);
begin
  DoDebugLn([EDebugLn.YELLOW], Hint);
end;

procedure TSimbaScriptRunner.DoTerm(Sender: TObject);
begin
  Application.Terminate();
  while (not Application.Terminated) do
    Application.ProcessMessages();

  {$IFDEF COCOA_TERMINATE_FIX}
  NSApplication.sharedApplication.postEvent_AtStart(
    nsEvent.otherEventWithType_location_modifierFlags_timestamp_windowNumber_context_subtype_data1_data2(
      NSApplicationDefined, GetNSPoint(0, 0), 0, NSTimeIntervalSince1970, 0, nil, 0, 0, 0
    ),
    True
  );
  {$ENDIF}
end;

procedure TSimbaScriptRunner.DoInputThread;
var
  Stream: THandleStream;
  State: ESimbaScriptState;
begin
  Stream := THandleStream.Create(StdInputHandle);
  while Stream.Read(State, SizeOf(ESimbaScriptState)) = SizeOf(ESimbaScriptState) do
    FScript.State := State;
  Stream.Free();
end;

procedure TSimbaScriptRunner.DoError(E: Exception);
var
  Line: String;
begin
  ExitCode := 1;

  DoDebugLn([EDebugLn.RED], E.Message);

  if (E is lpException) then
    with lpException(E) do
    begin
      for Line in StackTrace.Split(LineEnding) do
        if (Line <> '') then
          DoDebugLn([EDebugLn.RED], Line);

      if (FScript.SimbaCommunication <> nil) then
        FScript.SimbaCommunication.ScriptError(Message, DocPos.Line, DocPos.Col, DocPos.FileName);
    end;
end;

procedure TSimbaScriptRunner.Execute;
begin
  try
    ExecuteInThread(@DoInputThread);

    try
      if FScript.Compile() then
        DoDebugLn([EDebugLn.GREEN], 'Succesfully compiled in %.2f milliseconds.'.Format([FScript.CompileTime]));
    except
      on E: Exception do
      begin
        DoError(E);
        Exit;
      end;
    end;

    if not FCompileOnly then
    try
      FScript.Run();

      if (FScript.RunningTime < 10000) then
        DoDebugLn([EDebugLn.GREEN], 'Succesfully executed in %.2f milliseconds.'.Format([FScript.RunningTime]))
      else
        DoDebugLn([EDebugLn.GREEN], 'Succesfully executed in %s.'.Format([FormatMilliseconds(FScript.RunningTime, '\[hh:mm:ss\]')]));
    except
      on E: Exception do
        DoError(E);
    end;
  finally
    FScript.Free(); // Free the script in thread so it hopefully doesn't nuke the process
  end;
end;

constructor TSimbaScriptRunner.Create(FileName: String; SimbaCommunication, TargetWindow: String; CompileOnly: Boolean);
begin
  inherited Create(False);

  FreeOnTerminate := True;
  OnTerminate := @DoTerm;

  FCompileOnly := CompileOnly;

  FScript := TSimbaScript.Create();
  FScript.Script := TSimbaFile.FileRead(FileName);
  FScript.ScriptFileName := FileName;
  FScript.SimbaCommunicationServer := SimbaCommunication;
  FScript.TargetWindow := TargetWindow;

  // Simba created a temp file. Most likely default script.
  if FileIsInDirectory(FileName, SimbaEnv.TempPath) then
  begin
    FScript.ScriptFileName := ChangeFileExt(ExtractFileName(FileName), '');

    // temp file, so delete.
    if FileExists(FileName) then
      DeleteFile(FileName);
  end;
end;

end.

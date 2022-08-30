{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.script_communication;

{$i simba.inc}

interface

uses
  classes, sysutils, extctrls,
  simba.ipc, simba.mufasatypes, simba.bitmap;

type
  TSimbaScriptCommunication = class(TSimbaIPCClient)
  protected
    procedure BeginInvoke(Message: ESimbaCommunicationMessage); overload;
  public
    function GetSimbaTargetWindow: PtrUInt;
    function GetSimbaTargetPID: PtrUInt;
    function GetSimbaPID: PtrUInt;

    procedure ScriptError(Message: String; Line, Column: Integer; FileName: String);
    procedure ScriptStateChanged(State: ESimbaScriptState);

    procedure ShowBalloonHint(Title, Hint: String; Timeout: Integer; Flags: TBalloonFlags);

    procedure Status(S: String);
    procedure Disguse(S: String);

    procedure DebugImage_SetMaxSize(Width, Height: Integer);
    procedure DebugImage_MoveTo(X, Y: Integer);
    procedure DebugImage_Show(Bitmap: TMufasaBitmap; EnsureVisible: Boolean);
    procedure DebugImage_Update(Bitmap: TMufasaBitmap);
    procedure DebugImage_Hide;
    procedure DebugImage_Display(Width, Height: Integer); overload;
    procedure DebugImage_Display(X, Y, Width, Height: Integer); overload;

    procedure DebugMethodName(Name: String);
    procedure DebugEvents(Events: TMemoryStream);
  end;

implementation

procedure TSimbaScriptCommunication.BeginInvoke(Message: ESimbaCommunicationMessage);
begin
  BeginInvoke(Ord(Message));
end;

function TSimbaScriptCommunication.GetSimbaTargetWindow: PtrUInt;
begin
  BeginInvoke(ESimbaCommunicationMessage.SIMBA_TARGET_WINDOW);

  try
    Invoke();

    FResult.Read(Result, SizeOf(PtrUInt));
  finally
    EndInvoke();
  end;
end;

function TSimbaScriptCommunication.GetSimbaTargetPID: PtrUInt;
begin
  BeginInvoke(ESimbaCommunicationMessage.SIMBA_TARGET_PID);

  try
    Invoke();

    FResult.Read(Result, SizeOf(PtrUInt));
  finally
    EndInvoke();
  end;
end;

function TSimbaScriptCommunication.GetSimbaPID: PtrUInt;
begin
  BeginInvoke(ESimbaCommunicationMessage.SIMBA_PID);

  try
    Invoke();

    FResult.Read(Result, SizeOf(PtrUInt));
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.ScriptError(Message: String; Line, Column: Integer; FileName: String);
begin
  BeginInvoke(ESimbaCommunicationMessage.SCRIPT_ERROR);

  try
    FParams.WriteAnsiString(Message);
    FParams.WriteAnsiString(FileName);
    FParams.Write(Line, SizeOf(Integer));
    FParams.Write(Column, SizeOf(Integer));

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.ScriptStateChanged(State: ESimbaScriptState);
begin
  BeginInvoke(ESimbaCommunicationMessage.SCRIPT_STATE_CHANGE);

  try
    FParams.Write(State, SizeOf(ESimbaScriptState));

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.ShowBalloonHint(Title, Hint: String; Timeout: Integer; Flags: TBalloonFlags);
begin
  BeginInvoke(ESimbaCommunicationMessage.BALLOON_HINT);

  try
    FParams.WriteAnsiString(Title);
    FParams.WriteAnsiString(Hint);
    FParams.Write(Timeout, SizeOf(Integer));
    FParams.Write(Flags, SizeOf(Flags));

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.Status(S: String);
begin
  BeginInvoke(ESimbaCommunicationMessage.STATUS);

  try
    FParams.WriteAnsiString(S);

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.Disguse(S: String);
begin
  BeginInvoke(ESimbaCommunicationMessage.DISGUSE);

  try
    FParams.WriteAnsiString(S);

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.DebugImage_SetMaxSize(Width, Height: Integer);
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUGIMAGE_MAXSIZE);

  try
    FParams.Write(Width, SizeOf(Integer));
    FParams.Write(Height, SizeOf(Integer));

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.DebugImage_MoveTo(X, Y: Integer);
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUGIMAGE_MOVETO);

  try
    FParams.Write(X, SizeOf(Integer));
    FParams.Write(Y, SizeOf(Integer));

    Invoke();
  finally
    EndInvoke();
  end;
end;

// Send chunked ... faster & less memory needed.
procedure TSimbaScriptCommunication.DebugImage_Show(Bitmap: TMufasaBitmap; EnsureVisible: Boolean);
var
  Header: TSimbaIPCHeader;
  Y: Integer;
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUGIMAGE_SHOW);

  try
    Header.Size      := 0;
    Header.MessageID := FMessageID;

    FOutputStream.Write(Header, SizeOf(TSimbaIPCHeader));
    FOutputStream.Write(EnsureVisible, SizeOf(Boolean));
    FOutputStream.Write(Bitmap.Width, SizeOf(Integer));
    FOutputStream.Write(Bitmap.Height, SizeOf(Integer));

    for Y := 0 to Bitmap.Height - 1 do
      FOutputStream.Write(Bitmap.Data[Y * Bitmap.Width], Bitmap.Width * SizeOf(TRGB32));

    // Read result
    FInputStream.Read(Header, SizeOf(TSimbaIPCHeader));
    if (Header.Size > 0) then
    begin
      FResult.CopyFrom(FInputStream, Header.Size);
      FResult.Position := 0;
    end;
  finally
    EndInvoke();
  end;
end;

// Send chunked ... faster & less memory needed.
// Data is sent row by row
procedure TSimbaScriptCommunication.DebugImage_Update(Bitmap: TMufasaBitmap);
var
  Header: TSimbaIPCHeader;
  Y: Integer;
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUGIMAGE_UPDATE);

  try
    Header.Size      := 0;
    Header.MessageID := FMessageID;

    FOutputStream.Write(Header, SizeOf(TSimbaIPCHeader));
    FOutputStream.Write(Bitmap.Width, SizeOf(Integer));
    FOutputStream.Write(Bitmap.Height, SizeOf(Integer));

    for Y := 0 to Bitmap.Height - 1 do
      FOutputStream.Write(Bitmap.Data[Y * Bitmap.Width], Bitmap.Width * SizeOf(TRGB32));

    // Read result
    FInputStream.Read(Header, SizeOf(TSimbaIPCHeader));
    if (Header.Size > 0) then
    begin
      FResult.CopyFrom(FInputStream, Header.Size);
      FResult.Position := 0;
    end;
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.DebugImage_Hide;
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUGIMAGE_HIDE);

  try
    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.DebugImage_Display(Width, Height: Integer);
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUGIMAGE_DISPLAY);

  try
    FParams.Write(Width, SizeOf(Integer));
    FParams.Write(Height, SizeOf(Integer));

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.DebugImage_Display(X, Y, Width, Height: Integer);
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUGIMAGE_DISPLAY_XY);

  try
    FParams.Write(X, SizeOf(Integer));
    FParams.Write(Y, SizeOf(Integer));
    FParams.Write(Width, SizeOf(Integer));
    FParams.Write(Height, SizeOf(Integer));

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.DebugMethodName(Name: String);
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUG_METHOD_NAME);

  try
    FParams.WriteAnsiString(Name);

    Invoke();
  finally
    EndInvoke();
  end;
end;

procedure TSimbaScriptCommunication.DebugEvents(Events: TMemoryStream);
var
  Count: Integer;
begin
  BeginInvoke(ESimbaCommunicationMessage.DEBUG_EVENTS);

  try
    Count := Events.Position div SizeOf(TSimbaScriptDebuggerEvent);

    FParams.Write(Count, SizeOf(Integer));
    FParams.Write(Events.Memory^, Events.Position);

    Invoke();
  finally
    EndInvoke();
  end;
end;

end.


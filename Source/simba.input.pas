{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.input;

{$i simba.inc}

interface

uses
  Classes, SysUtils, Math,
  simba.base, simba.target, simba.simplelock, simba.baseclass;

type
  PSimbaInput = ^TSimbaInput;
  TSimbaInput = record
  const
    DEFAULT_KEY_PRESS_MIN = 20;
    DEFAULT_KEY_PRESS_MAX = 125;

    DEFAULT_CLICK_MIN = 40;
    DEFAULT_CLICK_MAX = 220;

    DEFAULT_MOUSE_TIMEOUT = 15000;
    DEFAULT_MOUSE_SPEED   = 10;
    DEFAULT_MOUSE_GRAVITY = 9;
    DEFAULT_MOUSE_WIND    = 4;
  type
    TMouseTeleportEvent = procedure(var Input: TSimbaInput; P: TPoint) of object;
    TMouseMovingEvent = procedure(var Input: TSimbaInput; var X, Y, DestX, DestY: Double; var Stop: Boolean) of object;
    TMouseButtonEvent = procedure(var Input: TSimbaInput; Button: EMouseButton) of object;
    TMouseEventArray = array of TMethod;
  public
    Target: TSimbaTarget;

    TeleportEvents: TMouseEventArray;
    MovingEvents: TMouseEventArray;
    ClickEvents: TMouseEventArray;
    DownEvents: TMouseEventArray;
    UpEvents: TMouseEventArray;

    function GetRandomKeyPressTime: Integer;
    function GetRandomMouseClickTime: Integer;

    function GetSpeed: Double;
    function GetGravity: Double;
    function GetWind: Double;
    function GetMouseTimeout: Integer;

    procedure AddEvent(var Arr: TMouseEventArray; Event: TMethod);
    procedure RemoveEvent(var Arr: TMouseEventArray; Event: TMethod);

    procedure CallOnMouseClickEvents(Button: EMouseButton);
    procedure CallOnMouseUpEvents(Button: EMouseButton);
    procedure CallOnMouseDownEvents(Button: EMouseButton);
    procedure CallOnTeleportEvents(P: TPoint);
    function CallOnMovingEvents(var X, Y, DestX, DestY: Double): Boolean;
  public
    KeyPressMin: Integer;
    KeyPressMax: Integer;

    MouseClickMin: Integer;
    MouseClickMax: Integer;

    MouseSpeed: Double;
    MouseGravity: Double;
    MouseWind: Double;
    MouseAccuracy: Double;

    MouseTimeout: Integer;

    function IsTargetValid: Boolean;
    function IsFocused: Boolean;
    function Focus: Boolean;

    function MousePosition: TPoint;
    function MousePressed(Button: EMouseButton): Boolean;
    procedure MouseMove(Dest: TPoint);
    procedure MouseClick(Button: EMouseButton);
    procedure MouseTeleport(P: TPoint);
    procedure MouseDown(Button: EMouseButton);
    procedure MouseUp(Button: EMouseButton);
    procedure MouseScroll(Scrolls: Integer);

    procedure KeySend(Text: String);
    procedure KeyPress(Key: EKeyCode);
    procedure KeyDown(Key: EKeyCode);
    procedure KeyUp(Key: EKeyCode);
    function KeyPressed(Key: EKeyCode): Boolean;

    function CharToKeyCode(C: Char): EKeyCode;

    function AddOnMouseTeleport(Event: TMouseTeleportEvent): TMouseTeleportEvent;
    function AddOnMouseMoving(Event: TMouseMovingEvent): TMouseMovingEvent;
    function AddOnMouseDown(Event: TMouseButtonEvent): TMouseButtonEvent;
    function AddOnMouseUp(Event: TMouseButtonEvent): TMouseButtonEvent;
    function AddOnMouseClick(Event: TMouseButtonEvent): TMouseButtonEvent;

    procedure RemoveOnMouseTeleport(Event: TMouseTeleportEvent);
    procedure RemoveOnMouseMoving(Event: TMouseMovingEvent);
    procedure RemoveOnMouseDown(Event: TMouseButtonEvent);
    procedure RemoveOnMouseUp(Event: TMouseButtonEvent);
    procedure RemoveOnMouseClick(Event: TMouseButtonEvent);

    function Copy: TSimbaInput;

    class operator Initialize(var Self: TSimbaInput);
  end;

implementation

uses
  simba.math, simba.nativeinterface, simba.random, simba.threading;

function TSimbaInput.GetRandomKeyPressTime: Integer;
begin
  if (KeyPressMin = 0) and (KeyPressMax = 0) then
    Result := RandomLeft(DEFAULT_KEY_PRESS_MIN, DEFAULT_KEY_PRESS_MAX)
  else
    Result := RandomLeft(KeyPressMin, KeyPressMax);
end;

function TSimbaInput.GetRandomMouseClickTime: Integer;
begin
  if (MouseClickMin = 0) and (MouseClickMax = 0) then
    Result := RandomLeft(DEFAULT_CLICK_MIN, DEFAULT_CLICK_MAX)
  else
    Result := RandomLeft(MouseClickMin, MouseClickMax);
end;

function TSimbaInput.GetSpeed: Double;
begin
  if (MouseSpeed = 0) then
    Result := DEFAULT_MOUSE_SPEED
  else
    Result := MouseSpeed;
end;

function TSimbaInput.GetGravity: Double;
begin
  if (MouseGravity = 0) then
    Result := DEFAULT_MOUSE_GRAVITY
  else
    Result := MouseGravity;
end;

function TSimbaInput.GetWind: Double;
begin
  if (MouseWind = 0) then
    Result := DEFAULT_MOUSE_WIND
  else
    Result := MouseWind;
end;

function TSimbaInput.GetMouseTimeout: Integer;
begin
  if (MouseTimeout = 0) then
    Result := DEFAULT_MOUSE_TIMEOUT
  else
    Result := MouseTimeout;
end;

procedure TSimbaInput.AddEvent(var Arr: TMouseEventArray; Event: TMethod);
var
  I: Integer;
begin
  // check duplicate
  for I := 0 to High(Arr) do
    if (Arr[I].Code = Event.Code) and (Arr[I].Data = Event.Data) then
      Exit;

  Arr += [Event];
end;

procedure TSimbaInput.RemoveEvent(var Arr: TMouseEventArray; Event: TMethod);
var
  I: Integer;
begin
  for I := High(Arr) downto 0 do
    if (Arr[I].Code = Event.Code) and (Arr[I].Data = Event.Data) then
      Delete(Arr, I, 1);
end;

procedure TSimbaInput.CallOnMouseClickEvents(Button: EMouseButton);
var
  Method: TMethod;
begin
  for Method in ClickEvents do
    TMouseButtonEvent(Method)(Self, Button);
end;

procedure TSimbaInput.CallOnMouseUpEvents(Button: EMouseButton);
var
  Method: TMethod;
begin
  for Method in UpEvents do
    TMouseButtonEvent(Method)(Self, Button);
end;

procedure TSimbaInput.CallOnMouseDownEvents(Button: EMouseButton);
var
  Method: TMethod;
begin
  for Method in DownEvents do
    TMouseButtonEvent(Method)(Self, Button);
end;

function TSimbaInput.IsTargetValid: Boolean;
begin
  Result := Target.IsValid();
end;

function TSimbaInput.IsFocused: Boolean;
begin
  Result := Target.IsFocused();
end;

function TSimbaInput.Focus: Boolean;
begin
  Result := Target.Focus();
end;

function TSimbaInput.MousePosition: TPoint;
begin
  Result := Target.MousePosition();
end;

function TSimbaInput.MousePressed(Button: EMouseButton): Boolean;
begin
  Result := Target.MousePressed(Button);
end;

procedure TSimbaInput.MouseMove(Dest: TPoint);

  // Credit: BenLand100 (https://github.com/BenLand100/SMART/blob/master/src/EventNazi.java#L201)
  procedure WindMouse(xs, ys, xe, ye, gravity, wind, minWait, maxWait, maxStep, targetArea: Double);
  var
    x, y, destX, destY: Double;
    veloX, veloY, windX, windY, veloMag, randomDist, idle: Double;
    remainingDist, acc, step: Double;
    Timeout: UInt64;
  begin
    veloX := 0; veloY := 0;
    windX := 0; windY := 0;

    x := xs;
    y := ys;
    destX := xe;
    destY := ye;

    acc := MouseAccuracy + 0.5;
    step := maxStep;

    Timeout := GetTickCount64() + GetMouseTimeout();

    while CallOnMovingEvents(x, y, xe, ye) do
    begin
      if (GetTickCount64() > Timeout) then
        SimbaException('MouseMove timed out after %dms. Start: (%d,%d), Dest: (%d,%d)', [GetMouseTimeout(), Round(xs), Round(ys), Round(xe), Round(ye)]);

      remainingDist := Hypot(x - xe, y - ye);
      if (remainingDist <= acc) then
        Break;

      // If destination changed ensure step is appropriate
      if ((xe <> destX) or (ye <> destY)) and (remainingDist > targetArea) then
        step := maxStep;
      destX := xe;
      destY := ye;

      if (remainingDist > targetArea) then
      begin
        wind := Min(wind, remainingDist);
        windX := windX / SQRT_3 + (Random(Round(wind) * 2 + 1) - wind) / SQRT_5;
        windY := windY / SQRT_3 + (Random(Round(wind) * 2 + 1) - wind) / SQRT_5;
      end else
      begin
        windX /= SQRT_3;
        windY /= SQRT_3;
        if (step < 3) then
          step := 3 + (Random() * 3)
        else
          step /= SQRT_5;
      end;

      veloX := veloX + windX;
      veloY := veloY + windY;
      veloX := veloX + gravity * (xe - x) / remainingDist;
      veloY := veloY + gravity * (ye - y) / remainingDist;

      if (Hypot(veloX, veloY) > step) then
      begin
        randomDist := step / 3.0 + (step / 2 * Random());

        veloMag := Sqrt(veloX * veloX + veloY * veloY);
        veloX := (veloX / veloMag) * randomDist;
        veloY := (veloY / veloMag) * randomDist;
      end;

      x := x + veloX;
      y := y + veloY;
      idle := (maxWait - minWait) * (Hypot(veloX, veloY) / step) + minWait;

      Self.MouseTeleport(TPoint.Create(Round(x), Round(y)));

      SimbaNativeInterface.PreciseSleep(Round(idle));
    end;
  end;

var
  Start: TPoint;
  RandSpeed, Expo: Double;
begin
  Start := MousePosition();

  // Further the distance the faster we move
  Expo := 1 + Power(Hypot(Start.X - Dest.X, Start.Y - Dest.Y), 0.5) / 50;

  RandSpeed := RandomLeft(GetSpeed(), GetSpeed() * 1.5);
  RandSpeed *= Expo;
  RandSpeed /= 10;

  WindMouse(
    Start.X, Start.Y, Dest.X, Dest.Y,
    GetGravity(), GetWind(),
    5 / RandSpeed, 10 / RandSpeed, 10 * RandSpeed, 15 * RandSpeed
  );
end;

procedure TSimbaInput.MouseClick(Button: EMouseButton);
begin
  CallOnMouseClickEvents(Button);

  Target.MouseDown(Button);
  SimbaNativeInterface.PreciseSleep(GetRandomMouseClickTime());
  Target.MouseUp(Button);
end;

procedure TSimbaInput.MouseTeleport(P: TPoint);
begin
  Target.MouseTeleport(P);

  CallOnTeleportEvents(P);
end;

procedure TSimbaInput.MouseDown(Button: EMouseButton);
begin
  CallOnMouseDownEvents(Button);

  Target.MouseDown(Button);
end;

procedure TSimbaInput.MouseUp(Button: EMouseButton);
begin
  CallOnMouseUpEvents(Button);

  Target.MouseUp(Button);
end;

procedure TSimbaInput.MouseScroll(Scrolls: Integer);
begin
  Target.MouseScroll(Scrolls);
end;

procedure TSimbaInput.KeySend(Text: String);
var
  I: Integer;
  SleepTimes: TIntegerArray;
begin
  if (Length(Text) = 0) then
    Exit;

  SetLength(SleepTimes, Length(Text) * 4);
  for I := 0 to High(SleepTimes) do
    SleepTimes[I] := GetRandomKeyPressTime();

  Target.KeySend(PChar(Text), @SleepTimes[0]);
end;

procedure TSimbaInput.KeyPress(Key: EKeyCode);
begin
  Target.KeyDown(Key);
  SimbaNativeInterface.PreciseSleep(GetRandomKeyPressTime());
  Target.KeyUp(Key);
end;

procedure TSimbaInput.KeyDown(Key: EKeyCode);
begin
  Target.KeyDown(Key);
end;

procedure TSimbaInput.KeyUp(Key: EKeyCode);
begin
  Target.KeyUp(Key);
end;

function TSimbaInput.KeyPressed(Key: EKeyCode): Boolean;
begin
  Result := Target.KeyPressed(Key);
end;

function TSimbaInput.CharToKeyCode(C: Char): EKeyCode;
begin
  case C of
    '0'..'9': Result := EKeyCode(Ord(EKeyCode.NUM_0) + Ord(C) - Ord('0'));
    'a'..'z': Result := EKeyCode(Ord(EKeyCode.A) + Ord(C) - Ord('a'));
    'A'..'Z': Result := EKeyCode(Ord(EKeyCode.A) + Ord(C) - Ord('A'));
    #34, #39: Result := EKeyCode.OEM_7;
    #32: Result := EKeyCode.SPACE;
    '!': Result := EKeyCode.NUM_1;
    '#': Result := EKeyCode.NUM_3;
    '$': Result := EKeyCode.NUM_4;
    '%': Result := EKeyCode.NUM_5;
    '&': Result := EKeyCode.NUM_7;
    '(': Result := EKeyCode.NUM_9;
    ')': Result := EKeyCode.NUM_0;
    '*': Result := EKeyCode.NUM_8;
    '+': Result := EKeyCode.ADD;
    ',': Result := EKeyCode.OEM_COMMA;
    '-': Result := EKeyCode.OEM_MINUS;
    '.': Result := EKeyCode.OEM_PERIOD;
    '/': Result := EKeyCode.OEM_2;
    ':': Result := EKeyCode.OEM_1;
    ';': Result := EKeyCode.OEM_1;
    '<': Result := EKeyCode.OEM_COMMA;
    '=': Result := EKeyCode.ADD;
    '>': Result := EKeyCode.OEM_PERIOD;
    '?': Result := EKeyCode.OEM_2;
    '@': Result := EKeyCode.NUM_2;
    '[': Result := EKeyCode.OEM_4;
    '\': Result := EKeyCode.OEM_5;
    ']': Result := EKeyCode.OEM_6;
    '^': Result := EKeyCode.NUM_6;
    '_': Result := EKeyCode.OEM_MINUS;
    '`': Result := EKeyCode.OEM_3;
    '{': Result := EKeyCode.OEM_4;
    '|': Result := EKeyCode.OEM_5;
    '}': Result := EKeyCode.OEM_6;
    '~': Result := EKeyCode.OEM_3;
    else
      Result := EKeyCode.UNKNOWN;
  end;
end;

procedure TSimbaInput.CallOnTeleportEvents(P: TPoint);
var
  Method: TMethod;
begin
  for Method in TeleportEvents do
    TMouseTeleportEvent(Method)(Self, P);
end;

function TSimbaInput.CallOnMovingEvents(var X, Y, DestX, DestY: Double): Boolean;
var
  Method: TMethod;
  Stop: Boolean = False;
begin
  Result := True;

  for Method in MovingEvents do
  begin
    TMouseMovingEvent(Method)(Self, X, Y, DestX, DestY, Stop);

    if Stop then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TSimbaInput.AddOnMouseTeleport(Event: TMouseTeleportEvent): TMouseTeleportEvent;
begin
  Result := Event;

  AddEvent(TeleportEvents, TMethod(Event));
end;

function TSimbaInput.AddOnMouseMoving(Event: TMouseMovingEvent): TMouseMovingEvent;
begin
  Result := Event;

  AddEvent(MovingEvents, TMethod(Event));
end;

function TSimbaInput.AddOnMouseDown(Event: TMouseButtonEvent): TMouseButtonEvent;
begin
  Result := Event;

  AddEvent(TeleportEvents, TMethod(Event));
end;

function TSimbaInput.AddOnMouseUp(Event: TMouseButtonEvent): TMouseButtonEvent;
begin
  Result := Event;

  AddEvent(UpEvents, TMethod(Event));
end;

function TSimbaInput.AddOnMouseClick(Event: TMouseButtonEvent): TMouseButtonEvent;
begin
  Result := Event;

  AddEvent(ClickEvents, TMethod(Event));
end;

procedure TSimbaInput.RemoveOnMouseTeleport(Event: TMouseTeleportEvent);
begin
  RemoveEvent(TeleportEvents, TMethod(Event));
end;

procedure TSimbaInput.RemoveOnMouseMoving(Event: TMouseMovingEvent);
begin
  RemoveEvent(MovingEvents, TMethod(Event));
end;

procedure TSimbaInput.RemoveOnMouseDown(Event: TMouseButtonEvent);
begin
  RemoveEvent(DownEvents, TMethod(Event));
end;

procedure TSimbaInput.RemoveOnMouseUp(Event: TMouseButtonEvent);
begin
  RemoveEvent(UpEvents, TMethod(Event));
end;

procedure TSimbaInput.RemoveOnMouseClick(Event: TMouseButtonEvent);
begin
  RemoveEvent(ClickEvents, TMethod(Event));
end;

function TSimbaInput.Copy: TSimbaInput;

  procedure MakeUnique(var Arr: TMouseEventArray);
  begin
    if (Pointer(Arr) <> nil) then
      Arr := System.Copy(Arr);
  end;

begin
  Result := Self;

  MakeUnique(Result.TeleportEvents);
  MakeUnique(Result.MovingEvents);
  MakeUnique(Result.ClickEvents);
  MakeUnique(Result.DownEvents);
  MakeUnique(Result.UpEvents);
end;

class operator TSimbaInput.Initialize(var Self: TSimbaInput);
begin
  Self := Default(TSimbaInput);
end;

end.


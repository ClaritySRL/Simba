{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.misc;

{$i simba.inc}

interface

uses
  classes, sysutils, process;

procedure ConvertTime(Time: Int64; var h, m, s: Int32);
procedure ConvertTime64(Time: Int64; var y, m, w, d, h, min, s: Int32);
function TimeStamp(Time: Int64; IncludeMilliseconds: Boolean = False): String;
function PerformanceTimer: Double;
function OpenDirectory(Path: String): Boolean;
procedure SetTerminalVisible(Value: Boolean);
procedure PlaySound(FileName: String);
procedure StopSound;

implementation

uses
  Forms,
  {$IFDEF WINDOWS}
  Windows, MMSystem
  {$ENDIF}
  {$IFDEF UNIX}
  BaseUnix, Unix
  {$ENDIF};

procedure ConvertTime(Time: Int64; var h, m, s: Int32);
var
  x: Int64;
begin
  x := time;
  h := x div (3600000);
  x := x mod (3600000);
  m := x div (60000);
  x := x mod (60000);
  s := x div (1000);
end;

procedure ConvertTime64(Time: Int64; var y, m, w, d, h, min, s: Int32);
var
  x: Int64;
begin
  x := time;
  y := x div (31536000000); // 1000 * 60 * 60 * 24 * 365 (1 year or 365 days)
  x := x mod (31536000000);
  m := x div (2592000000); // 1000 * 60 * 60 * 24 * 30 (1 month or 30 days)
  x := x mod (2592000000);
  w := x div (604800000); // 1000 * 60 * 60 * 24 * 7 (1 week or 7 days)
  x := x mod (604800000);
  d := x div (86400000); // 1000 * 60 * 60 * 24 (1 day or 24 hours)
  x := x mod (86400000);
  h := x div (3600000); // 1000 * 60 * 60 (1 hour or 60 minutes)
  x := x mod (3600000);
  min := x div (60000); // 1000 * 60 (1 minute or 60 seconds)
  x := x mod (60000);
  s := x div (1000); // 1000 (1 second)
  x := x mod (1000);
end;

function TimeStamp(Time: Int64; IncludeMilliseconds: Boolean): String;
var
  Hours, Mins, Secs, Milliseconds: Int32;
begin
  Hours := Time div 3600000;
  Time  := Time mod 3600000;
  Mins  := Time div 60000;
  Time  := Time mod 60000;
  Secs  := Time div 1000;
  Milliseconds  := Time mod 1000;

  if IncludeMilliseconds then
    Result := Format('[%.2d:%.2d:%.2d:%.3d]', [Hours, Mins, Secs, Milliseconds])
  else
    Result := Format('[%.2d:%.2d:%.2d]', [Hours, Mins, Secs]);
end;

function PerformanceTimer: Double;
var
  Frequency, Count: Int64;
  {$IFDEF UNIX}
  TV: TTimeVal;
  TZ: PTimeZone;
  {$ENDIF}
begin
  Result := 0;

  {$IFDEF WINDOWS}
  QueryPerformanceFrequency(Frequency);
  QueryPerformanceCounter(Count);
  Result := Count / Frequency * 1000;
  {$ENDIF}

  {$IFDEF UNIX}
  TZ := nil;
  fpGetTimeOfDay(@TV, TZ);
  Count := Int64(TV.tv_sec) * 1000000 + Int64(TV.tv_usec);
  Result := Count / 1000;
  {$ENDIF}
end;

function OpenDirectory(Path: String): Boolean;
var
  Executable: String = '';
  Output: String;
  ExitStatus: Int32;
begin
  {$IFDEF WINDOWS}
  Executable := 'explorer.exe';
  Path := '/root,"' + Path + '"';
  {$ENDIF}

  {$IFDEF LINUX}
  Executable := 'xdg-open';
  {$ENDIF}

  {$IFDEF DARWIN}
  Executable := 'open';
  {$ENDIF}

  if (Executable = '') then
    raise Exception.Create('OpenDirectory is unsupported on this system.');

  Result := RunCommandInDir('', Executable, [Path], Output, ExitStatus) = 0;
end;

procedure SetTerminalVisible(Value: Boolean);
var
  PID: UInt32;
begin
  {$IFDEF WINDOWS}
  GetWindowThreadProcessId(GetConsoleWindow(), PID);

  if (PID = GetCurrentProcessID()) then
  begin
    case Value of
      True: ShowWindow(GetConsoleWindow(), SW_SHOWNORMAL);
      False: ShowWindow(GetConsoleWindow(), SW_HIDE);
    end;
  end;
  {$ENDIF}
end;

procedure PlaySound(FileName: String);
begin
  {$IFDEF WINDOWS}
  sndPlaySound(PChar(FileName), SND_ASYNC or SND_NODEFAULT);
  {$ENDIF}
end;

procedure StopSound;
begin
  {$IFDEF WINDOWS}
  sndPlaySound(nil, 0);
  {$ENDIF}
end;

end.


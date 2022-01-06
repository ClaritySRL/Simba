{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.helpers_string;

{$i simba.inc}

interface

uses
  classes, sysutils,
  simba.mufasatypes;

type
  PRegExprGroup = ^TRegExprGroup;
  TRegExprGroup = record
    Position: Integer;
    Length: Integer;
    Match: String;
  end;
  TRegExprGroups = array of TRegExprGroup;

  PRegExprMatch = ^TRegExprMatch;
  TRegExprMatch = record
    Position: Integer;
    Length: Integer;
    Match: String;

    Groups: TRegExprGroups;
  end;
  PRegExprMatches = ^TRegExprMatches;
  TRegExprMatches = array of TRegExprMatch;

  TSimbaStringHelper = type helper for String
  public
    class function NumberChars: String; static;
    class function AlphaChars: String; static;
    class function LowerChars: String; static;
    class function UpperChars: String; static;

    function ToUpper: String;
    function ToLower: String;
    function Capitalize: String;

    function Before(const Value: String): String;
    function After(const Value: String): String;

    function Between(const S1, S2: String): String;
    function BetweenAll(const S1, S2: String): TStringArray;

    function RegExprSplit(const Pattern: String): TStringArray;
    function RegExprFindAll(const Pattern: String): TRegExprMatches;
    function RegExprFind(const Pattern: String): TRegExprMatch;
    function RegExprExists(const Pattern: String): Boolean;

    function IndexOfAny(const Values: TStringArray): Integer; overload;
    function IndexOfAny(const Values: TStringArray; Offset: Integer): Integer; overload;

    function IndexOf(const Value: String): Integer; overload;
    function IndexOf(const Value: String; Offset: Integer): Integer; overload;
    function LastIndexOf(const Value: String): Integer; overload;
    function LastIndexOf(const Value: String; Offset: Integer): Integer; overload;

    function IndicesOfChar(const Value: Char; Offset: Integer): TIntegerArray;

    function IndicesOf(const Value: String): TIntegerArray; overload;
    function IndicesOf(const Value: String; Offset: Integer): TIntegerArray; overload;

    function Extract(const Characters: String): String;
    function ExtractNumber(Default: Int64 = -1): Int64; overload;
    function IsNumber: Boolean; overload;

    function Trim: String; overload;
    function Trim(const TrimChars: array of Char): String; overload;

    function TrimLeft: String; overload;
    function TrimLeft(const TrimChars: array of Char): String; overload;

    function TrimRight: String; overload;
    function TrimRight(const TrimChars: array of Char): String; overload;

    function StartsWith(const Value: String; CaseSenstive: Boolean = True): Boolean;
    function EndsWith(const Value: String; CaseSenstive: Boolean = True): Boolean;

    function Replace(const OldValue: String; const NewValue: String): String; overload;
    function Replace(const OldValue: String; const NewValue: String; ReplaceFlags: TReplaceFlags): String; overload;

    function Contains(const Value: String; CaseSenstive: Boolean = True): Boolean;
    function ContainsAny(const Values: TStringArray; CaseSenstive: Boolean = True): Boolean;

    function Count(const Value: String): Integer;

    function Split(const Seperator: String): TStringArray;

    function Copy: String; overload;
    function Copy(StartIndex, Count: Integer): String; overload;
    function Copy(StartIndex: Integer): String; overload;
    function CopyRange(StartIndex, EndIndex: Integer): String;

    procedure Delete(StartIndex, Count: Integer);
    procedure DeleteRange(StartIndex, EndIndex: Integer);

    procedure Insert(const Value: String; Index: Integer);

    function PadLeft(Count: Integer; PaddingChar: Char = #32): String; overload;
    function PadRight(Count: Integer; PaddingChar: Char = #32): String; overload;
  end;

  operator * (Left: String; Right: Int32): String;
  operator in(Left: String; Right: String): Boolean;
  operator in(Left: String; Right: TStringArray): Boolean;

implementation

uses
  strutils, uregexpr,
  simba.overallocatearray;

function TSimbaStringHelper.Before(const Value: String): String;
var
  P: Integer;
begin
  P := Pos(Value, Self);
  if (P = 0) then
    Result := ''
  else
    Result := System.Copy(Self, 1, P - 1);
end;

function TSimbaStringHelper.After(const Value: String): String;
var
  P: Integer;
begin
  P := Pos(Value, Self);
  if (P = 0) then
    Result := ''
  else
    Result := System.Copy(Self, P + System.Length(Value), (System.Length(Self) - System.Length(Value)) + 1);
end;

function TSimbaStringHelper.Between(const S1, S2: String): String;
var
  I, J: Integer;
begin
  Result := '';

  I := System.Pos(S1, Self);
  if (I > 0) then
  begin
    I := I + System.Length(S1);
    J := System.Pos(S2, Self, I);
    if (J > 0) then
      Result := System.Copy(Self, I, J-I);
  end;
end;

function TSimbaStringHelper.BetweenAll(const S1, S2: String): TStringArray;

  procedure Add(var Offset: Integer);
  var
    I: Integer;
  begin
    Offset := System.Pos(S1, Self, Offset);

    if (Offset > 0) then
    begin
      Offset := Offset + System.Length(S1);
      I := System.Pos(S2, Self, Offset);
      if (I > 0) then
        Result := Result + [System.Copy(Self, Offset, I - Offset)];
    end;
  end;

var
  Offset: Integer;
begin
  Result := Default(TStringArray);

  Offset := 1;
  while (Offset > 0) do
    Add(Offset);
end;

function TSimbaStringHelper.RegExprSplit(const Pattern: String): TStringArray;
var
  PrevPos: PtrInt;
  RegExpr: TRegExpr;
begin
  Result := Default(TStringArray);

  PrevPos := 1;

  RegExpr := TRegExpr.Create(Pattern);
  try
    if RegExpr.Exec(Self) then
    repeat
      Result := Result + [System.Copy(Self, PrevPos, RegExpr.MatchPos[0] - PrevPos)];

      PrevPos := RegExpr.MatchPos[0] + RegExpr.MatchLen[0];
    until not RegExpr.ExecNext();
  finally
    RegExpr.Free();
  end;

  Result := Result + [System.Copy(Self, PrevPos)];
end;

function TSimbaStringHelper.RegExprFind(const Pattern: String): TRegExprMatch;
var
  RegExpr: TRegExpr;

  function Add: TRegExprMatch;
  var
    Group: TRegExprGroup;
    I: Integer;
  begin
    Result.Match    := RegExpr.Match[0];
    Result.Length   := RegExpr.MatchLen[0];
    Result.Position := RegExpr.MatchPos[0];

    SetLength(Result.Groups, RegExpr.SubExprMatchCount);

    for I := 0 to RegExpr.SubExprMatchCount - 1 do
    begin
      Group.Match    := RegExpr.Match[I+1];
      Group.Length   := RegExpr.MatchLen[I+1];
      Group.Position := RegExpr.MatchPos[I+1];

      Result.Groups[I] := Group;
    end;
  end;

begin
  Result := Default(TRegExprMatch);

  RegExpr := TRegExpr.Create(Pattern);
  try
    if RegExpr.Exec(Self) then
      Result := Add();
  finally
    RegExpr.Free();
  end;
end;

function TSimbaStringHelper.RegExprExists(const Pattern: String): Boolean;
var
  RegExpr: TRegExpr;
begin
  RegExpr := TRegExpr.Create(Pattern);
  try
    Result := RegExpr.Exec(Self);
  finally
    RegExpr.Free();
  end;
end;

function TSimbaStringHelper.RegExprFindAll(const Pattern: String): TRegExprMatches;
var
  RegExpr: TRegExpr;

  function Add: TRegExprMatch;
  var
    Group: TRegExprGroup;
    I: Integer;
  begin
    Result.Match    := RegExpr.Match[0];
    Result.Length   := RegExpr.MatchLen[0];
    Result.Position := RegExpr.MatchPos[0];

    SetLength(Result.Groups, RegExpr.SubExprMatchCount);

    for I := 0 to RegExpr.SubExprMatchCount - 1 do
    begin
      Group.Match    := RegExpr.Match[I+1];
      Group.Length   := RegExpr.MatchLen[I+1];
      Group.Position := RegExpr.MatchPos[I+1];

      Result.Groups[I] := Group;
    end;
  end;

begin
  RegExpr := TRegExpr.Create(Pattern);
  try
    if RegExpr.Exec(Self) then
    repeat
      Result := Result + [Add()];
    until not RegExpr.ExecNext();
  finally
    RegExpr.Free();
  end;
end;

function TSimbaStringHelper.IndexOfAny(const Values: TStringArray): Integer;
begin
  Result := IndexOfAny(Values, 1);
end;

function TSimbaStringHelper.IndexOfAny(const Values: TStringArray; Offset: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to High(Values) do
  begin
    Result := Self.IndexOf(Values[I], Offset);
    if (Result > 0) then
      Exit;
  end;
end;

function TSimbaStringHelper.IndexOf(const Value: String): Integer;
begin
  Result := Pos(Value, Self);
end;

function TSimbaStringHelper.IndexOf(const Value: String; Offset: Integer): Integer;
begin
  Result := Pos(Value, Self, Offset);
end;

function TSimbaStringHelper.LastIndexOf(const Value: String): Integer;
begin
  Result := RPos(Value, Self);
end;

function TSimbaStringHelper.LastIndexOf(const Value: String; Offset: Integer): Integer;
begin
  Result := RPosEx(Value, Self, Offset);
end;

function TSimbaStringHelper.IndicesOfChar(const Value: Char; Offset: Integer): TIntegerArray;
var
  Matches: specialize TSimbaOverAllocateArray<Integer>;
  I: Integer;
begin
  Matches.Init(32);

  if (Offset > 0) then
    for I := Offset to Length(Self) do
      if (Self[I] = Value) then
        Matches.Add(I);

  Result := Matches.Trim();
end;

function TSimbaStringHelper.IndicesOf(const Value: String): TIntegerArray;
var
  Matches: SizeIntArray;
  I: Integer;
begin
  Result := Default(TIntegerArray);
  if (Self = '') then
    Exit;

  if Length(Value) = 1 then
    Result := IndicesOfChar(Value[1], 1)
  else
  if FindMatchesBoyerMooreCaseSensitive(Self, Value, Matches, True) then
  begin
    SetLength(Result, System.Length(Matches));
    for I := 0 to High(Matches) do
      Result[I] := Matches[I];
  end;
end;

function TSimbaStringHelper.IndicesOf(const Value: String; Offset: Integer): TIntegerArray;
var
  Matches: SizeIntArray;
  I: Integer;
begin
  Result := Default(TIntegerArray);
  if (Self = '') then
    Exit;

  if Length(Value) = 1 then
    Result := IndicesOfChar(Value[1], Offset)
  else
  if FindMatchesBoyerMooreCaseSensitive(Self.Copy(Offset, MaxInt), Value, Matches, True) then
  begin
    SetLength(Result, System.Length(Matches));
    for I := 0 to High(Matches) do
      Result[I] := Matches[I];
  end;
end;

class function TSimbaStringHelper.NumberChars: String;
begin
  Result := '0123456789';
end;

class function TSimbaStringHelper.AlphaChars: String;
begin
  Result := 'abcdefghijklmnopqrstuvwxyz' + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
end;

class function TSimbaStringHelper.LowerChars: String;
begin
 Result := 'abcdefghijklmnopqrstuvwxyz';
end;

class function TSimbaStringHelper.UpperChars: String;
begin
 Result := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
end;

function TSimbaStringHelper.ToUpper: String;
begin
  Result := UpperCase(Self);
end;

function TSimbaStringHelper.ToLower: String;
begin
  Result := LowerCase(Self);
end;

function TSimbaStringHelper.Capitalize: String;
var
  I: Integer;
begin
  SetLength(Result, Length(Self));

  for I := 1 to Length(Self) do
    if (I = 1) then
      Result[I] := UpCase(Self[I])
    else
      Result[I] := LowerCase(Self[I]);
end;

function TSimbaStringHelper.Extract(const Characters: String): String;
var
  I, Count: Integer;
begin
  SetLength(Result, System.Length(Self));
  Count := 1;

  for I := 1 to System.Length(Self) do
    if Pos(Self[I], Characters) > 0 then
    begin
      Result[Count] := Self[I];
      Inc(Count);
    end;

  SetLength(Result, Count - 1);
end;

function TSimbaStringHelper.ExtractNumber(Default: Int64): Int64;
begin
  Result := StrToIntDef(Extract('0123456789-.'), Default);
end;

function TSimbaStringHelper.IsNumber: Boolean;
var
  I: Integer;
begin
  Result := False;
  if Length(Self) > 0 then
  begin
    for I := 1 to Length(Self) do
      if (not (Self[I] in ['0'..'9'] + ['-', '.'])) then
        Exit;

    Result := True;
  end;
end;

function TSimbaStringHelper.Trim: String;
begin
  Result := SysUtils.Trim(Self);
end;

function TSimbaStringHelper.Trim(const TrimChars: array of Char): String;
begin
  Result := Self.TrimLeft(TrimChars).TrimRight(TrimChars);
end;

function TSimbaStringHelper.TrimLeft: String;
begin
  Result := SysUtils.TrimLeft(Self);
end;

function TSimbaStringHelper.TrimLeft(const TrimChars: array of Char): String;

  function IsTrimChar(C: Char): Boolean; inline;
  var
    I: Integer;
  begin
    for I := 0 to High(TrimChars) do
      if (C = TrimChars[I]) then
        Exit(True);
    Result := False;
  end;

var
  I, Len: SizeInt;
begin
  I := 1;
  Len := System.Length(Self);
  while (I <= Len) and IsTrimChar(Self[I]) do
    Inc(I);

  if (I = 1) then
    Result := Self
  else if (I > Len) then
    Result := ''
  else
    Result := System.Copy(Self, I, Len-I+1);
end;

function TSimbaStringHelper.TrimRight: String;
begin
  Result := SysUtils.TrimRight(Self);
end;

function TSimbaStringHelper.TrimRight(const TrimChars: array of Char): String;

  function IsTrimChar(C: Char): Boolean; inline;
  var
    I: Integer;
  begin
    for I := 0 to High(TrimChars) do
      if (C = TrimChars[I]) then
        Exit(True);
    Result := False;
  end;

var
  I, Len: SizeInt;
begin
  Len := System.Length(Self);
  I := Len;
  while (I >= 1) and IsTrimChar(Self[I]) do
    Dec(I);

  if (I < 1) then
    Result := ''
  else if (I = Len) then
    Result := Self
  else
    Result := System.Copy(Self, 1, I);
end;

function TSimbaStringHelper.StartsWith(const Value: String; CaseSenstive: Boolean): Boolean;
begin
  case CaseSenstive of
    False: Result := SameText(Copy(1, Length(Value)), Value);
    True:  Result := System.Copy(Self, 1, Length(Value)) = Value;
  end;
end;

function TSimbaStringHelper.EndsWith(const Value: String; CaseSenstive: Boolean): Boolean;
begin
  case CaseSenstive of
    False: Result := SameText(System.Copy(Self, Length(Self) - Length(Value) + 1), Value);
    True:  Result := System.Copy(Self, Length(Self) - Length(Value) + 1) = Value;
  end;
end;

function TSimbaStringHelper.Replace(const OldValue: String; const NewValue: String): String;
begin
  Result := StringReplace(Self, OldValue, NewValue, [rfReplaceAll]);
end;

function TSimbaStringHelper.Replace(const OldValue: String; const NewValue: String; ReplaceFlags: TReplaceFlags): String;
begin
  Result := StringReplace(Self, OldValue, NewValue, ReplaceFlags)
end;

function TSimbaStringHelper.Contains(const Value: String; CaseSenstive: Boolean): Boolean;
begin
  Result := ContainsAny([Value], CaseSenstive);
end;

function TSimbaStringHelper.ContainsAny(const Values: TStringArray; CaseSenstive: Boolean): Boolean;
var
  I: Integer;
begin
  case CaseSenstive of
    True:
      for I := 0 to High(Values) do
        if Self.IndexOf(Values[I]) > 0 then
          Exit(True);

    False:
      for I := 0 to High(Values) do
        if Self.ToLower().IndexOf(Values[I].ToLower()) > 0 then
          Exit(True);
  end;

  Result := False;
end;

function TSimbaStringHelper.Count(const Value: String): Integer;
begin
  Result := Length(IndicesOf(Value));
end;

function TSimbaStringHelper.Split(const Seperator: String): TStringArray;
var
  Len: SizeInt;

  function NextSep(const StartIndex: SizeInt): SizeInt;
  begin
    Result := Self.IndexOf(Seperator, StartIndex);
  end;

  procedure Append(const S: String);
  begin
    if (Len >= Length(Result)) then
      SetLength(Result, Length(Result) * 2);
    Result[Len] := S;
    Inc(Len);
  end;

var
  Sep, LastSep: SizeInt;
begin
  SetLength(Result, 16);

  Len := 0;
  LastSep := 1;
  Sep := NextSep(1);
  while (Sep > 0) do
  begin
    Append(Copy(LastSep, Sep - LastSep));

    LastSep := Sep + Length(Seperator);
    Sep := NextSep(LastSep);
  end;

  if (LastSep <= Length(Self)) then
    Append(Copy(LastSep, MaxInt));

  if (Len > 0) and (Result[Len - 1] = '') then
    Dec(Len);

  SetLength(Result, Len);
end;

function TSimbaStringHelper.Copy: String;
begin
  Result := System.Copy(Self, 1, Length(Self));
end;

function TSimbaStringHelper.Copy(StartIndex, Count: Integer): String;
begin
  Result := System.Copy(Self, StartIndex, Count);
end;

function TSimbaStringHelper.Copy(StartIndex: Integer): String;
begin
  Result := System.Copy(Self, StartIndex, MaxInt);
end;

function TSimbaStringHelper.CopyRange(StartIndex, EndIndex: Integer): String;
begin
  Result := System.Copy(Self, StartIndex, (EndIndex - StartIndex) + 1);
end;

procedure TSimbaStringHelper.Delete(StartIndex, Count: Integer);
begin
  System.Delete(Self, StartIndex, Count);
end;

procedure TSimbaStringHelper.DeleteRange(StartIndex, EndIndex: Integer);
begin
  System.Delete(Self, StartIndex, (EndIndex - StartIndex) + 1);
end;

procedure TSimbaStringHelper.Insert(const Value: String; Index: Integer);
begin
  System.Insert(Value, Self, Index);
end;

function TSimbaStringHelper.PadLeft(Count: Integer; PaddingChar: Char): String;
begin
  Count := Count - Length(Self);
  if (Count > 0) then
    Result := StringOfChar(PaddingChar, Count) + Self
  else
    Result := Self;
end;

function TSimbaStringHelper.PadRight(Count: Integer; PaddingChar: Char): String;
begin
  Count := Count - Length(Self);
  if (Count > 0) then
    Result := Self + StringOfChar(PaddingChar, Count)
  else
    Result := Self;
end;

operator *(Left: String; Right: Int32): String;
var
  I, Len: Integer;
begin
  Result := Left;

  Len := Length(Left);
  if (Len > 0) then
  begin
    SetLength(Result, Len * Right);
    for I := 1 to Right - 1 do
      Move(Left[1], Result[1+Len*I], Len);
  end;
end;

operator in(Left: String; Right: String): Boolean;
begin
  Result := Pos(Left, Right) > 0;
end;

operator in(Left: String; Right: TStringArray): Boolean;
var
  I: Integer;
begin
  for I := 0 to High(Right) do
    if Pos(Left, Right[I]) > 0 then
    begin
      Result := True;
      Exit;
    end;

  Result := False;
end;

end.


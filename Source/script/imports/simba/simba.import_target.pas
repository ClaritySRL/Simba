unit simba.import_target;

{$i simba.inc}

interface

uses
  Classes, SysUtils;

implementation

uses
  lptypes, lpvartypes,
  simba.script_compiler, simba.mufasatypes, simba.bitmap, simba.target;


(*
Target
======
Target related methods.
*)

(*
TSimbaTarget.SetDesktop
~~~~~~~~~~~~~~~~~~~~~~~
procedure TSimbaTarget.SetDesktop;

Sets the desktop as the target.
*)
procedure _LapeSimbaTarget_SetDesktop(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaTarget(Params^[0])^.SetDesktop();
end;

(*
TSimbaTarget.SetBitmap
~~~~~~~~~~~~~~~~~~~~~~
procedure TSimbaTarget.SetBitmap(Bitmap: TMufasaBitmap);

Sets the bitmap as a target.

Note: Ownership of the bitmap is **not** taken. Make sure you do not free the bitmap while using this target.
*)
procedure _LapeSimbaTarget_SetBitmap(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaTarget(Params^[0])^.SetBitmap(PMufasaBitmap(Params^[1])^);
end;

(*
TSimbaTarget.SetWindow
~~~~~~~~~~~~~~~~~~~~~~
procedure TSimbaTarget.SetWindow(Window: TWindowHandle);

Sets a window handle as a target.
*)
procedure _LapeSimbaTarget_SetWindow(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaTarget(Params^[0])^.SetWindow(PWindowHandle(Params^[1])^);
end;

(*
TSimbaTarget.SetEIOS
~~~~~~~~~~~~~~~~~~~~
procedure TSimbaTarget.SetEIOS(Plugin, Args: String);

Sets a plugin (via EIOS API) as the target.
*)
procedure _LapeSimbaTarget_SetEIOS(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaTarget(Params^[0])^.SetEIOS(PString(Params^[1])^, PString(Params^[2])^);
end;

(*
TSimbaTarget.GetImage
~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.GetImage(Bounds: TBox = [-1,-1,-1,-1]): TMufasaBitmap;
*)
procedure _LapeSimbaTarget_GetImage(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PMufasaBitmap(Result)^ := PSimbaTarget(Params^[0])^.GetImage(PBox(Params^[1])^);
end;

(*
TSimbaTarget.GetDimensions
~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TSimbaTarget.GetDimensions(out Width, Height: Integer);
*)
procedure _LapeSimbaTarget_GetDimensions(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaTarget(Params^[0])^.GetDimensions(PInteger(Params^[1])^, PInteger(Params^[2])^);
end;

(*
TSimbaTarget.GetWidth
~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.GetWidth: Integer;
*)
procedure _LapeSimbaTarget_GetWidth(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PInteger(Result)^ := PSimbaTarget(Params^[0])^.GetWidth();
end;

(*
TSimbaTarget.GetHeight
~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.GetHeight: Integer;
*)
procedure _LapeSimbaTarget_GetHeight(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PInteger(Result)^ := PSimbaTarget(Params^[0])^.GetHeight();
end;

(*
TSimbaTarget.IsValid
~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsValid: Boolean;
*)
procedure _LapeSimbaTarget_IsValid(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.IsValid();
end;

(*
TSimbaTarget.IsFocused
~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsFocused: Boolean;
*)
procedure _LapeSimbaTarget_IsFocused(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.IsFocused();
end;

(*
TSimbaTarget.Focus
~~~~~~~~~~~~~~~~~~
function TSimbaTarget.Focus: Boolean;
*)
procedure _LapeSimbaTarget_Focus(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.Focus();
end;

(*
TSimbaTarget.IsWindowTarget
~~~~~~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsWindowTarget: Boolean;
*)
procedure _LapeSimbaTarget_IsWindowTarget1(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.IsWindowTarget();
end;

(*
TSimbaTarget.IsWindowTarget
~~~~~~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsWindowTarget(out Window: TWindowHandle): Boolean;
*)
procedure _LapeSimbaTarget_IsWindowTarget2(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.IsWindowTarget(PWindowHandle(Params^[1])^)
end;

(*
TSimbaTarget.IsBitmapTarget
~~~~~~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsBitmapTarget: Boolean;
*)
procedure _LapeSimbaTarget_IsBitmapTarget1(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.IsBitmapTarget();
end;

(*
TSimbaTarget.IsBitmapTarget
~~~~~~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsBitmapTarget(out Bitmap: TMufasaBitmap): Boolean;
*)
procedure _LapeSimbaTarget_IsBitmapTarget2(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.IsBitmapTarget(PMufasaBitmap(Params^[1])^);
end;

(*
TSimbaTarget.IsEIOSTarget
~~~~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsEIOSTarget: Boolean;
*)
procedure _LapeSimbaTarget_IsEIOSTarget(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaTarget(Params^[0])^.IsEIOSTarget();
end;

(*
TSimbaTarget.IsDefault
~~~~~~~~~~~~~~~~~~~~~~
function TSimbaTarget.IsDefault: Boolean;
*)
procedure _LapeSimbaTarget_IsDefault(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := CompareMem(PSimbaTarget(Params^[0]), @Default(TSimbaTarget), SizeOf(TSimbaTarget));
end;

procedure ImportTarget(Compiler: TSimbaScript_Compiler);
begin
  with Compiler do
  begin
    ImportingSection := 'Target';

    addGlobalType([
      'packed record',
      '  {%CODETOOLS OFF}',
      '  InternalData: array[0..' + IntToStr(SizeOf(TSimbaTarget) - 1)  + '] of Byte;',
      '  {%CODETOOLS ON}',
      'end;'],
      'TSimbaTarget'
    );
    if (getGlobalType('TSimbaTarget').Size <> SizeOf(TSimbaTarget)) then
      raise Exception.Create('SizeOf(TSimbaTarget) is wrong!');

    with addGlobalVar('TSimbaTarget', '[]', 'Target') do
      Used := duTrue;

    addGlobalFunc('procedure TSimbaTarget.SetDesktop', @_LapeSimbaTarget_SetDesktop);
    addGlobalFunc('procedure TSimbaTarget.SetBitmap(Bitmap: TMufasaBitmap)', @_LapeSimbaTarget_SetBitmap);
    addGlobalFunc('procedure TSimbaTarget.SetWindow(Window: TWindowHandle)', @_LapeSimbaTarget_SetWindow);
    addGlobalFunc('procedure TSimbaTarget.SetEIOS(Plugin, Args: String)', @_LapeSimbaTarget_SetEIOS);

    addGlobalFunc('function TSimbaTarget.GetImage(Bounds: TBox = [-1,-1,-1,-1]): TMufasaBitmap', @_LapeSimbaTarget_GetImage);
    addGlobalFunc('procedure TSimbaTarget.GetDimensions(out Width, Height: Integer)', @_LapeSimbaTarget_GetDimensions);
    addGlobalFunc('function TSimbaTarget.GetWidth: Integer', @_LapeSimbaTarget_GetWidth);
    addGlobalFunc('function TSimbaTarget.GetHeight: Integer', @_LapeSimbaTarget_GetHeight);

    addGlobalFunc('function TSimbaTarget.IsValid: Boolean', @_LapeSimbaTarget_IsValid);
    addGlobalFunc('function TSimbaTarget.IsFocused: Boolean', @_LapeSimbaTarget_IsFocused);
    addGlobalFunc('function TSimbaTarget.Focus: Boolean', @_LapeSimbaTarget_Focus);

    addGlobalFunc('function TSimbaTarget.IsWindowTarget: Boolean; overload', @_LapeSimbaTarget_IsWindowTarget1);
    addGlobalFunc('function TSimbaTarget.IsWindowTarget(out Window: TWindowHandle): Boolean; overload', @_LapeSimbaTarget_IsWindowTarget2);
    addGlobalFunc('function TSimbaTarget.IsBitmapTarget: Boolean; overload', @_LapeSimbaTarget_IsBitmapTarget1);
    addGlobalFunc('function TSimbaTarget.IsBitmapTarget(out Bitmap: TMufasaBitmap): Boolean; overload', @_LapeSimbaTarget_IsBitmapTarget2);
    addGlobalFunc('function TSimbaTarget.IsEIOSTarget: Boolean', @_LapeSimbaTarget_IsEIOSTarget);

    addGlobalFunc('function TSimbaTarget.IsDefault: Boolean', @_LapeSimbaTarget_IsDefault);

    ImportingSection := 'TMufasaBitmap';

    addGlobalFunc(
      'function TMufasaBitmap.CreateFromTarget(Target: TSimbaTarget; Bounds: TBox = [-1,-1,-1,-1]): TMufasaBitmap; static; overload;', [
      'begin',
      '  Result := Target.GetImage();',
      'end;'
    ]);
    addGlobalFunc(
      'function TMufasaBitmap.CreateFromTarget(Bounds: TBox = [-1,-1,-1,-1]): TMufasaBitmap; static; overload;', [
      'begin',
      '  Result := TMufasaBitmap.CreateFromTarget(System.Target, Bounds);',
      'end;'
    ]);

    addGlobalFunc(
      'procedure TMufasaBitmap.DrawTarget(Target: TSimbaTarget; P: TPoint; Bounds: TBox = [-1,-1,-1,-1]); overload;', [
      'var',
      '  Image: TMufasaBitmap;',
      'begin',
      '  Image := TMufasaBitmap.CreateFromTarget(Target, Bounds);',
      '  Self.DrawBitmap(Image, P);',
      '  Image.Free();',
      'end;'
    ]);
    addGlobalFunc(
      'procedure TMufasaBitmap.DrawTarget(P: TPoint; Bounds: TBox = [-1,-1,-1,-1]); overload;', [
      'begin',
      '  Self.DrawTarget(System.Target, P, Bounds);',
      'end;'
    ]);
  end;
end;

initialization
  TSimbaScript_Compiler.RegisterImport(@ImportTarget);

end.


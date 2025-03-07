unit simba.import_json;

{$i simba.inc}

interface

uses
  Classes, SysUtils,
  simba.base, simba.script_compiler;

procedure ImportJson(Compiler: TSimbaScript_Compiler);

implementation

uses
  lptypes,
  simba.json;

type
  PSimbaJSONElement = ^TSimbaJSONElement;
  PSimbaJSONParser = ^TSimbaJSONParser;

(*
JSON
====
JSON parser.

It is `Variant` based and the parser must be freed.

```
var
  JsonParser: TJsonParser;
  Element: TJSONElement;
  I: Integer;
begin
  JsonParser := TJSONParser.Create();

  Element := JsonParser.AddObject('someObject');
  Element.AddValue('someInteger', 123);
  Element.AddValue('someString', 'HelloWorld');

  for I := 0 to Element.Count - 1 do
    WriteLn(Element.Item[I].ValueType);
end.
```
*)

(*
TJSONElement.Keys
-----------------
> property TJSONElement.Keys: TStringArray;
*)
procedure _LapeJSONElement_Keys_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PStringArray(Result)^ := PSimbaJSONElement(Params^[0])^.Keys;
end;

(*
TJSONElement.Values
-------------------
> property TJSONElement.Values: TVariantArray;
*)
procedure _LapeJSONElement_Values_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PVariantArray(Result)^ := PSimbaJSONElement(Params^[0])^.Values;
end;

(*
TJSONElement.Count
------------------
> property TJSONElement.Count: Integer;
*)
procedure _LapeJSONElement_Count_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PInteger(Result)^ := PSimbaJSONElement(Params^[0])^.Count;
end;

(*
TJSONElement.Item
-----------------
> property TJSONElement.Item[Index: Integer]: TJSONElement;
*)
procedure _LapeJSONElement_Item_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONElement(Params^[0])^.Items[PInteger(Params^[1])^];
end;

(*
TJSONElement.ValueType
----------------------
> property TJSONElement.ValueType: EJSONValueType;
*)
procedure _LapeJSONElement_ValueType_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  ESimbaJSONValueType(Result^) := PSimbaJSONElement(Params^[0])^.ValueType;
end;

(*
TJSONElement.Value
------------------
> property TJSONElement.Value: Variant;
> property TJSONElement.Value(NewValue: Variant);
*)
procedure _LapeJSONElement_Value_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PVariant(Result)^ := PSimbaJSONElement(Params^[0])^.Value;
end;

procedure _LapeJSONElement_Value_Write(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Params^[0])^.Value := PVariant(Params^[1])^;
end;

(*
TJSONElement.IsValue
--------------------
> property TJSONElement.IsValue: Boolean;
*)
procedure _LapeJSONElement_IsValue_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONElement(Params^[0])^.IsValue;
end;

(*
TJSONElement.IsArray
--------------------
> property TJSONElement.IsArray: Boolean;
*)
procedure _LapeJSONElement_IsArray_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONElement(Params^[0])^.IsArray;
end;

(*
TJSONElement.IsObject
---------------------
> property TJSONElement.IsObject: Boolean;
*)
procedure _LapeJSONElement_IsObject_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONElement(Params^[0])^.IsObject;
end;

(*
TJSONElement.AsString
---------------------
> property TJSONElement.AsString: String;
*)
procedure _LapeJSONElement_AsString_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PString(Result)^ := PSimbaJSONElement(Params^[0])^.AsString;
end;

(*
TJSONElement.AddValue
---------------------
> procedure TJSONElement.AddValue(Key: String; Value: Variant);
*)
procedure _LapeJSONElement_AddValue(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Params^[0])^.AddValue(PString(Params^[1])^, PVariant(Params^[2])^);
end;

(*
TJSONElement.AddArray
---------------------
> function TJSONElement.AddArray(Key: String): TJSONElement;
*)
procedure _LapeJSONElement_AddArray1(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONElement(Params^[0])^.AddArray(PString(Params^[1])^);
end;

(*
TJSONElement.AddArray
---------------------
> function TJSONElement.AddArray(Key: String; Values: TVariantArray): TJSONElement;
*)
procedure _LapeJSONElement_AddArray2(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONElement(Params^[0])^.AddArray(PString(Params^[1])^, PVariantArray(Params^[2])^);
end;

(*
TJSONElement.AddObject
----------------------
> function TJSONElement.AddObject(Key: String): TJSONElement;
*)
procedure _LapeJSONElement_AddObject(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONElement(Params^[0])^.AddObject(PString(Params^[1])^);
end;

(*
TJSONElement.AddNull
--------------------
> function TJSONElement.AddNull(Key: String): TJSONElement;
*)
procedure _LapeJSONElement_AddNull(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONElement(Params^[0])^.AddNull(PString(Params^[1])^);
end;

(*
TJSONElement.AddElement
-----------------------
> procedure TJSONElement.AddElement(Key: String; Element: TJSONElement);
*)
procedure _LapeJSONElement_AddElement(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Params^[0])^.AddElement(PString(Params^[1])^, PSimbaJSONElement(Params^[2])^);
end;

(*
TJSONElement.Clone
------------------
> function TJSONElement.Clone: TJSONElement;
*)
procedure _LapeJSONElement_Clone(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONElement(Params^[0])^.Clone();
end;

(*
TJSONElement.Delete
-------------------
> procedure TJSONElement.Delete(Key: String);
*)
procedure _LapeJSONElement_Delete1(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Params^[0])^.Delete(PString(Params^[1])^);
end;

(*
TJSONElement.Delete
-------------------
> procedure TJSONElement.Delete(Index: Integer);
*)
procedure _LapeJSONElement_Delete2(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Params^[0])^.Delete(PInteger(Params^[1])^);
end;

(*
TJSONElement.Clear
------------------
> procedure TJSONElement.Clear;
*)
procedure _LapeJSONElement_Clear(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Params^[0])^.Clear();
end;

(*
TJSONElement.Find
-----------------
> function TJSONElement.Find(Key: String; out Element: TJSONElement): Boolean;
*)
procedure _LapeJSONElement_Find(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONElement(Params^[0])^.Find(PString(Params^[1])^, PSimbaJSONElement(Params^[2])^);
end;

(*
TJSONElement.HasKey
-------------------
> function TJSONElement.HasKey(Key: String): Boolean;

Returns `True` if the `Key` exists in the JSON object.
*)
procedure _LapeJSONElement_HasKey1(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONElement(Params^[0])^.HasKey(PString(Params^[1])^);
end;

(*
TJSONElement.HasKey
-------------------
> function TJSONElement.HasKey(Keys: TStringArray): Boolean;

Returns `True` if **any** of the `Keys` exists in the JSON object.
*)
procedure _LapeJSONElement_HasKey2(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONElement(Params^[0])^.HasKey(PStringArray(Params^[1])^);
end;

(*
TJSONElement.HasKeys
--------------------
> function TJSONElement.HasKeys(Keys: TStringArray): Boolean;

Returns `True` if **all** `Keys` exists in the JSON object.
*)
procedure _LapeJSONElement_HasKeys(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONElement(Params^[0])^.HasKeys(PStringArray(Params^[1])^);
end;

(*
TJSONParser.Create
------------------
> function TJSONParser.Create(Str: String = ''): TJSONParser; static;

Create a JSON Parser. Optional `Str` parameter which will parse the string into the parser.

- This needs to be free'd when finished.
- This is a `static` method.

Example:

```
var MyJsonParser: TJSONParser;
begin
  MyJsonParser := TJSONParser.Create();
  MyJsonParser.AddValue('someString', 'HelloWorld');
  MyJsonParser.AddValue('someInt', 1234);
  WriteLn MyJsonParser.AsString();
  MyJsonParser.Free();
end;
```
*)
procedure _LapeJSONParser_Create(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONParser(Result)^ := TSimbaJSONParser.Create(PString(Params^[0])^);
end;

(*
TJSONParser.CreateFromFile
--------------------------
> function TJSONParser.CreateFromFile(FileName: String): TJSONParser; static;

Create a JSON parser from a json file.

- This needs to be free'd when finished.
- This is a `static` method.

Example:

```
var MyJsonParser: TJSONParser;
begin
  MyJsonParser := TJSONParser.CreateFromFile('somefile.json');
  WriteLn(MyJsonParser.Keys());
  MyJsonParser.Free();
end;
```
*)
procedure _LapeJSONParser_CreateFromFile(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONParser(Result)^ := TSimbaJSONParser.Create(PString(Params^[0])^);
end;

(*
TJSONParser.SaveToFile
----------------------
> function TJSONParser.SaveToFile(FileName: String): Boolean;
*)
procedure _LapeJSONParser_SaveToFile(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONParser(Params^[0])^.SaveToFile(PString(Params^[1])^);
end;

(*
TJSONParser.Clear
-----------------
> procedure TJSONParser.Clear;
*)
procedure _LapeJSONParser_Clear(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONParser(Params^[0])^.Clear();
end;

(*
TJSONParser.AddNull
--------------------
> function TJSONParser.AddNull(Key: String): TJSONElement;
*)
procedure _LapeJSONParser_AddNull(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONParser(Params^[0])^.AddNull(PString(Params^[1])^);
end;

(*
TJSONParser.AddValue
--------------------
> procedure TJSONParser.AddValue(Key: String; Value: Variant);
*)
procedure _LapeJSONParser_AddValue(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONParser(Params^[0])^.AddValue(PString(Params^[1])^, PVariant(Params^[2])^);
end;

(*
TJSONParser.AddArray
--------------------
> function TJSONParser.AddArray(Key: String): TJSONElement;
> function TJSONParser.AddArray(Key: String; Values: TVariantArray): TSimbaJSONElement;
*)
procedure _LapeJSONParser_AddArray1(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONParser(Params^[0])^.AddArray(PString(Params^[1])^);
end;

procedure _LapeJSONParser_AddArray2(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONParser(Params^[0])^.AddArray(PString(Params^[1])^, PVariantArray(Params^[2])^);
end;

(*
TJSONParser.AddObject
---------------------
> function TJSONParser.AddObject(Key: String): TJSONElement;
*)
procedure _LapeJSONParser_AddObject(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONParser(Params^[0])^.AddObject(PString(Params^[1])^);
end;

(*
TJSONParser.AddElement
----------------------
> procedure TJSONParser.AddElement(Key: String; Element: TJSONElement);
*)
procedure _LapeJSONParser_AddElement(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONParser(Params^[0])^.AddElement(PString(Params^[1])^, PSimbaJSONElement(Params^[2])^);
end;

(*
TJSONParser.Find
----------------
> function TJSONParser.Find(Key: String; out Element: TJSONElement): Boolean;
*)
procedure _LapeJSONParser_Find(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONParser(Params^[0])^.Find(PString(Params^[1])^, PSimbaJSONElement(Params^[2])^);
end;

(*
TJSONParser.Delete
------------------
> procedure TJSONParser.Delete(Key: String);
*)
procedure _LapeJSONParser_Delete1(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONParser(Params^[0])^.Delete(PString(Params^[1])^);
end;

(*
TJSONParser.Delete
------------------
> procedure TJSONParser.Delete(Index: Integer);
*)
procedure _LapeJSONParser_Delete2(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONParser(Params^[0])^.Delete(PInteger(Params^[1])^);
end;

(*
TJSONParser.FindPath
--------------------
> function TJSONParser.FindPath(Path: String; out Element: TJSONElement): Boolean;
*)
procedure _LapeJSONParser_FindPath(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONParser(Params^[0])^.FindPath(PString(Params^[1])^, PSimbaJSONElement(Params^[2])^);
end;

(*
TJSONParser.HasKey
-------------------
> function TJSONParser.HasKey(Key: String): Boolean;

Returns `True` if the `Key` exists in the root JSON parser.
*)
procedure _LapeJSONParser_HasKey1(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONParser(Params^[0])^.HasKey(PString(Params^[1])^);
end;

(*
TJSONParser.HasKey
-------------------
> function TJSONParser.HasKey(Keys: TStringArray): Boolean;

Returns `True` if **any** of the `Keys` exists in the root JSON parser.
*)
procedure _LapeJSONParser_HasKey2(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONParser(Params^[0])^.HasKey(PStringArray(Params^[1])^);
end;

(*
TJSONParser.HasKeys
--------------------
> function TJSONParser.HasKeys(Keys: TStringArray): Boolean;

Returns `True` if **all** `Keys` exists in the root JSON parser.
*)
procedure _LapeJSONParser_HasKeys(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaJSONParser(Params^[0])^.HasKeys(PStringArray(Params^[1])^);
end;

(*
TJSONParser.Count
-----------------
> property TJSONParser.Count: Integer;
*)
procedure _LapeJSONParser_Count_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PInteger(Result)^ := PSimbaJSONParser(Params^[0])^.Count;
end;

(*
TJSONParser.Item
----------------
> property TJSONParser.Item[Index: Integer]: TJSONElement;
*)
procedure _LapeJSONParser_Item_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaJSONElement(Result)^ := PSimbaJSONParser(Params^[0])^.Items[PInteger(Params^[1])^];
end;

(*
TJSONParser.AsString
--------------------
> property TJSONParser.AsString: String;
*)
procedure _LapeJSONParser_AsString_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PString(Result)^ := PSimbaJSONParser(Params^[0])^.AsString;
end;

(*
TJSONParser.Values
------------------
> property TJSONParser.Values: TVariantArray;
*)
procedure _LapeJSONParser_Values_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PVariantArray(Result)^ := PSimbaJSONParser(Params^[0])^.Values;
end;

(*
TJSONParser.Keys
----------------
> function TJSONParser.Keys: TStringArray;
*)
procedure _LapeJSONParser_Keys_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PStringArray(Result)^ := PSimbaJSONParser(Params^[0])^.Keys;
end;

procedure ImportJSON(Compiler: TSimbaScript_Compiler);
begin
  with Compiler do
  begin
    ImportingSection := 'JSON';

    addGlobalType('enum(UNKNOWN, NULL, INT, FLOAT, STR, BOOL)', 'EJSONValueType');
    with addGlobalType('record {%CODETOOLS OFF}InternalData: Pointer;{%CODETOOLS ON} end', 'TJSONElement') do
      if (Size <> SizeOf(TSimbaJSONParser)) then
        SimbaException('SizeOf(TJSONElement) is wrong!');

    addGlobalFunc('procedure TJSONElement.AddValue(Key: String; Value: Variant)', @_LapeJSONElement_AddValue);
    addGlobalFunc('function TJSONElement.AddArray(Key: String): TJSONElement; overload;', @_LapeJSONElement_AddArray1);
    addGlobalFunc('function TJSONElement.AddArray(Key: String; Values: TVariantArray): TJSONElement; overload;', @_LapeJSONElement_AddArray2);
    addGlobalFunc('function TJSONElement.AddObject(Key: String): TJSONElement', @_LapeJSONElement_AddObject);
    addGlobalFunc('procedure TJSONElement.AddElement(Key: String; Element: TJSONElement)', @_LapeJSONElement_AddElement);
    addGlobalFunc('function TJSONElement.AddNull(Key: String): TJSONElement', @_LapeJSONElement_AddNull);
    addGlobalFunc('function TJSONElement.Clone: TJSONElement', @_LapeJSONElement_Clone);
    addGlobalFunc('procedure TJSONElement.Clear', @_LapeJSONElement_Clear);
    addGlobalFunc('procedure TJSONElement.Delete(Key: String); overload', @_LapeJSONElement_Delete1);
    addGlobalFunc('procedure TJSONElement.Delete(Index: Integer); overload', @_LapeJSONElement_Delete2);
    addGlobalFunc('function TJSONElement.Find(Key: String; out Element: TJSONElement): Boolean;', @_LapeJSONElement_Find);
    addGlobalFunc('function TJSONElement.HasKey(Key: String): Boolean; overload', @_LapeJSONElement_HasKey1);
    addGlobalFunc('function TJSONElement.HasKey(Keys: TStringArray): Boolean; overload', @_LapeJSONElement_HasKey2);
    addGlobalFunc('function TJSONElement.HasKeys(Keys: TStringArray): Boolean', @_LapeJSONElement_HasKeys);

    addPropertyIndexed('TJSONElement', 'Item', 'Index: Integer', 'TJSONElement', @_LapeJSONElement_Item_Read);
    addProperty('TJSONElement', 'Values', 'TVariantArray', @_LapeJSONElement_Values_Read);
    addProperty('TJSONElement', 'Keys', 'TStringArray', @_LapeJSONElement_Keys_Read);
    addProperty('TJSONElement', 'Count', 'Integer', @_LapeJSONElement_Count_Read);
    addProperty('TJSONElement', 'ValueType', 'EJSONValueType', @_LapeJSONElement_ValueType_Read);
    addProperty('TJSONElement', 'Value', 'Variant', @_LapeJSONElement_Value_Read, @_LapeJSONElement_Value_Write);
    addProperty('TJSONElement', 'IsValue', 'Boolean', @_LapeJSONElement_IsValue_Read);
    addProperty('TJSONElement', 'IsArray', 'Boolean', @_LapeJSONElement_IsArray_Read);
    addProperty('TJSONElement', 'IsObject', 'Boolean', @_LapeJSONElement_IsObject_Read);
    addProperty('TJSONElement', 'AsString', 'String', @_LapeJSONElement_AsString_Read);

    addDelayedCode([
      'function ToString(constref Param: TJSONElement): String; override;',
      'begin',
      '  Result := Param.AsString;',
      'end;'
    ]);

    addClass('TJSONParser');

    addGlobalFunc('function TJSONParser.Create(Str: String = ""): TJSONParser; static;', @_LapeJSONParser_Create);
    addGlobalFunc('function TJSONParser.CreateFromFile(FileName: String): TJSONParser; static', @_LapeJSONParser_CreateFromFile);
    addGlobalFunc('function TJSONParser.SaveToFile(FileName: String): Boolean', @_LapeJSONParser_SaveToFile);
    addGlobalFunc('procedure TJSONParser.Clear;', @_LapeJSONParser_Clear);
    addGlobalFunc('function TJSONParser.HasKey(Key: String): Boolean; overload', @_LapeJSONParser_HasKey1);
    addGlobalFunc('function TJSONParser.HasKey(Keys: TStringArray): Boolean; overload', @_LapeJSONParser_HasKey2);
    addGlobalFunc('function TJSONParser.HasKeys(Keys: TStringArray): Boolean', @_LapeJSONParser_HasKeys);
    addGlobalFunc('function TJSONParser.AddNull(Key: String): TJSONElement', @_LapeJSONParser_AddNull);
    addGlobalFunc('procedure TJSONParser.AddValue(Key: String; Value: Variant)', @_LapeJSONParser_AddValue);
    addGlobalFunc('function TJSONParser.AddArray(Key: String): TJSONElement; overload;', @_LapeJSONParser_AddArray1);
    addGlobalFunc('function TJSONParser.AddArray(Key: String; Values: TVariantArray): TJSONElement; overload;', @_LapeJSONParser_AddArray2);
    addGlobalFunc('function TJSONParser.AddObject(Key: String): TJSONElement;', @_LapeJSONParser_AddObject);
    addGlobalFunc('procedure TJSONParser.AddElement(Key: String; Element: TJSONElement)', @_LapeJSONParser_AddElement);
    addGlobalFunc('function TJSONParser.Find(Key: String; out Element: TJSONElement): Boolean;', @_LapeJSONParser_Find);
    addGlobalFunc('procedure TJSONParser.Delete(Key: String); overload;', @_LapeJSONParser_Delete1);
    addGlobalFunc('procedure TJSONParser.Delete(Index: Integer); overload;', @_LapeJSONParser_Delete2);
    addGlobalFunc('function TJSONParser.FindPath(Path: String; out Element: TJSONElement): Boolean;', @_LapeJSONParser_FindPath);

    addPropertyIndexed('TJSONParser', 'Item', 'Index: Integer', 'TJSONElement', @_LapeJSONParser_Item_Read);
    addProperty('TJSONParser', 'Values', 'TVariantArray', @_LapeJSONParser_Values_Read);
    addProperty('TJSONParser', 'Keys', 'TStringArray', @_LapeJSONParser_Keys_Read);
    addProperty('TJSONParser', 'Count', 'Integer', @_LapeJSONParser_Count_Read);
    addProperty('TJSONParser', 'AsString', 'String', @_LapeJSONParser_AsString_Read);

    ImportingSection := '';
  end;
end;

end.

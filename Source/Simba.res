        ˙˙  ˙˙                  ä      ˙˙ ˙˙               <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
 <assemblyIdentity version="1.0.0.0" processorArchitecture="*" name="Simba" type="win32"/>
 <description></description>
 <dependency>
  <dependentAssembly>
   <assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls" version="6.0.0.0" processorArchitecture="*" publicKeyToken="6595b64144ccf1df" language="*"/>
  </dependentAssembly>
 </dependency>
 <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
  <security>
   <requestedPrivileges>
    <requestedExecutionLevel level="asInvoker" uiAccess="false"/>
   </requestedPrivileges>
  </security>
 </trustInfo>
 <compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1">
  <application>
   <!-- Windows Vista -->
   <supportedOS Id="{e2011457-1546-43c5-a5fe-008deee3d3f0}" />
   <!-- Windows 7 -->
   <supportedOS Id="{35138b9a-5d96-4fbd-8e2d-a2440225f93a}" />
   <!-- Windows 8 -->
   <supportedOS Id="{4a2f28e3-53b9-4441-ba9c-d69d4a4a6e38}" />
   <!-- Windows 8.1 -->
   <supportedOS Id="{1f676c76-80e1-4239-95bb-83d0f6d0da78}" />
   <!-- Windows 10 -->
   <supportedOS Id="{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}" />
   </application>
  </compatibility>
 <asmv3:application xmlns:asmv3="urn:schemas-microsoft-com:asm.v3">
  <asmv3:windowsSettings xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">
   <dpiAware>True/PM_V2</dpiAware>
  </asmv3:windowsSettings>
  <asmv3:windowsSettings xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">
   <dpiAwareness>PerMonitorV2, PerMonitor</dpiAwareness>
   <longPathAware>false</longPathAware>
   
  </asmv3:windowsSettings>
 </asmv3:application>
</assembly>Ô      ˙˙ ˙˙               Ô4   V S _ V E R S I O N _ I N F O     ˝ďţ                 ?                        4   S t r i n g F i l e I n f o      0 8 0 9 0 4 B 0   8   C o m p a n y N a m e     v i l l a v u . c o m   h    F i l e D e s c r i p t i o n     S i m b a :   h t t p : / / w i z z u p . o r g / s i m b a /   < 
  O r i g i n a l F i l e n a m e   S i m b a . e x e   ,   P r o d u c t N a m e     S i m b a   ,   P r o d u c t V e r s i o n   2 . 0      C o m m e n t s       0   F i l e V e r s i o n     2 . 0 . 0 . 0   $   I n t e r n a l N a m e       (   L e g a l C o p y r i g h t       ,   L e g a l T r a d e m a r k s         D    V a r F i l e I n f o     $    T r a n s l a t i o n     	°>   0   ˙˙ M A I N I C O N                            h        	          ¨   00     ¨%     ł  8   ˙˙
 E X A M P L E _ A R R A Y                 var
  myArray: array of Int32;
begin
  myArray := [1,2,3,4,5,4,3,2,1];
  WriteLn myArray;

  // Length of array, or how many items it contains.
  WriteLn Length(myArray);

  // Index of last item which is Length(myArray) - 1
  WriteLn High(myArray);

  // access first element:
  WriteLn myArray[0];

  // access second element:
  WriteLn myArray[1];

  // access last item:
  WriteLn myArray[High(myArray)];
end;
   @   ˙˙
 E X A M P L E _ F U N C T I O N                   program FunctionExample;

function GetNumber: Integer;
begin
  Result := 10; 
end;

function GetText: String;
begin
  Result := 'Hello World'; 
end;

function MultiplyNumber(Number: Integer; MultiplyBy: Integer): Integer;
begin
  Result := Number * MultiplyBy;
end;

begin
  WriteLn(GetNumber());
  WriteLn(GetText());

  Writeln('10x10 = ', MultiplyNumber(10, 10));
end;     8   ˙˙
 E X A M P L E _ L O O P                   program LoopsExample;

procedure ForLoop;
var
  Counter: Integer;
begin
  WriteLn('ForLoop:');
  for Counter := 0 to 4 do
    WriteLn(Counter);
  WriteLn('ForLoop finished');
end;

procedure ForLoop_Break;
var
  Counter: Integer;
begin
  WriteLn('ForLoop_Break:');
  for Counter := 0 to 4 do
    if (Counter = 3) then // Exit the loop if counter is 3
      Break;
  WriteLn('ForLoop_Break finished: ', Counter);
end;

procedure ForLoop_Continue;
var
  Counter: Integer;
begin
  WriteLn('ForLoop_Continue:');
  for Counter := 0 to 4 do
  begin
    if (Counter = 2) or (Counter = 3) or (Counter = 4) then // Skip the loop if Counter is 2,3,4
      Continue;

    WriteLn(Counter);
  end;
  WriteLn('ForLoop_Continue finished');
end;

begin
  WriteLn('-------------------------------');
  ForLoop();
  WriteLn('-------------------------------');
  ForLoop_Break();
  WriteLn('-------------------------------');
  ForLoop_Continue();
  WriteLn('-------------------------------');
end.  ţ  @   ˙˙
 E X A M P L E _ S T O P W A T C H                 program StopWatchExample;

procedure SomethingToTime;
var
  Counter: Integer;
begin
  while (Counter < 100) do
  begin
    Sleep(Random(30));
    Inc(Counter);
  end;
end;

var
  StopWatch: TStopWatch;
  Milliseconds: Integer;
  Formatted: String;
begin
  StopWatch.Start();
  SomethingToTime();
  StopWatch.Stop();

  Milliseconds := StopWatch.Elapsed();
  Formatted := StopWatch.ElapsedFmt('s');

  WriteLn('Milliseconds: ', Milliseconds);
  WriteLN('Seconds: ', Formatted);
end.
  A  8   ˙˙
 E X A M P L E _ I M A G E                 var
  Img: TImage;
begin
  Img := TImage.Create(500, 500); // Images must explictly created and freed!
  Img.DrawBox([100,100,400,400], $0000FF);
  Img.DrawLine([50, 50], [450, 50], 5, $00FFFF);
  Img.SetPixel(250, 250, $FFFFFF);
  Img.SetFontSize(25);
  Img.SetFontAntialiasing(False);
  Img.DrawText('Hello world', [125, 125], $00FF00);

  WriteLn('Color at 250,250 is ', '$' + IntToHex(Img.GetPixel(250, 250)));
  WriteLn('Available fonts: ', Img.LoadedFontNames());

  Img.Show(); // Show on Simba's debug image
  Img.Free(); // Images must be freed
end. 
   h  L   ˙˙
 E X A M P L E _ C L U S T E R _ P O I N T S                   var
  TPA: TPointArray;
  ATPA: T2DPointArray;
  I: Integer;
begin
  // Create a random array to test on
  TPA := RandomTPA(100, [100,100,300,300]);
  TPA := TPA.Grow(3);

  // Cluster by 10 distance, if a point is not within 10 distance of any other
  // points in a group, add it to a new group.
  ATPA := TPA.Cluster(20);

  Show(ATPA);
end;
s  X   ˙˙
 E X A M P L E _ M O U S E _ T E L E P O R T _ E V E N T                   var
  TPA: TPointArray; // stores the teleport events so we can view at the end

procedure MouseTeleportEvent(var Sender: TInput; P: TPoint);
begin
  WriteLn('Mouse teleported to: ', P);
  TPA += P;
end;

var
  Event: TMouseTeleportEvent;
begin
  Event := Input.AddOnMouseTeleportEvent(@MouseTeleportEvent);
  Input.MouseTeleport([200,200]);
  Input.MouseMove([600,600]);
  Input.RemoveOnMouseTeleportEvent(Event); // Remove the event

  Input.MouseMove([200, 600]); // The event has been removed so this wont be "recorded" when we show the path

  Show(TPA); // Now we can see what actually happened
end;
   H   ˙˙
 E X A M P L E _ S T A T I C _ M E T H O D                 program StaticMethodExample;

type
  TSomeType = record
    x,y,z: Integer;
  end;

// A static method behave completely like regular procedures or functions
// They do not have a `Self` variable.
// Their use is mainly to include the method in the namespace of the type.
procedure TSomeType.Test; static;
begin
  // WriteLn(Self.X); // Will error as `Self` does not exist
  WriteLn('Hello from static method');
end;

begin
  TSomeType.Test();
end;

// Can also be called on a variable, but `Self` still wont exist.
// It is suggested not to call it this way.
var
  TestVar: TSomeType;
begin
  TestVar.Test();
end;
  Ě  8   ˙˙
 E X A M P L E _ J S O N                   const
  SOME_JSON_DATA =
    '{'                                                                       + LINE_SEP +
    '    "employee": {'                                                       + LINE_SEP +
    '        "name": "John",'                                                 + LINE_SEP +
    '        "age":  9000,'                                                   + LINE_SEP +
    '        "car":  false'                                                   + LINE_SEP +
    '    },'                                                                  + LINE_SEP +
    '   "weekdays": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]' + LINE_SEP +
    '}';

var
  JsonParser: TJSONParser;
  Element: TJSONElement;
  I, J: Integer;
begin
  JsonParser := TJSONParser.Create(SOME_JSON_DATA);

  for I := 0 to JSONParser.Count - 1 do
  begin
    Element := JsonParser.GetItem(I);
    if Element.IsObject() then
    begin
      WriteLn('Item[',I,'] is a json object:');
      WriteLn('Keys: ', Element.Keys);
      for J := 0 to Element.Count - 1 do
        WriteLn('  ', Element.GetItem(J).ValueType, ' -> ', Element.GetItem(J).GetValue());
    end;

    if Element.IsArray() then
    begin
      WriteLn('Item[',I,'] is a json array:');
      for J := 0 to Element.Count - 1 do
        WriteLn('  ', Element.GetItem(J).ValueType, ' -> ', Element.GetItem(J).GetValue());
    end;
  end;

  // change `john` name to `james`
  if JsonParser.Find('person', Element) then
    Element.GetItem(0).SetValue('james');

  // Add another employee
  Element := JsonParser.AddObject('anotherEmployee');
  Element.AddValue('name', 'bob');
  Element.AddValue('age', 123);
  Element.AddValue('car', True);

  // Get our updated json string
  WriteLn JsonParser.AsString();

  // JSON paths are also useful
  if JsonParser.FindPath('employee.name', Element) then
    WriteLn('Found employee.name! ', Element.AsString);

  JsonParser.Free();
end;
˙  8   ˙˙
 E X A M P L E _ F O R M                   // Simple form example doing random things.

var
  Form: TLazForm;

// Called when the mouse the mouse is pressed on the form
procedure FormMouseDown(Sender: TObject; Button: TLazMouseButton; Shift: TLazShiftState; X, Y: Integer);
begin
  WriteLn('FormMouseDown: ', Button, ', ', Shift, ' at ', X, ', ', Y);
  if (ssShift in Shift) then
    WriteLn('Shift is pressed too!');
  if (ssCtrl in Shift) then
    WriteLn('Control is pressed too!');
end;

// Called when the mouse the mouse is released on the form
procedure FormMouseUp(Sender: TObject; Button: TLazMouseButton; Shift: TLazShiftState; X, Y: Integer);
begin
  WriteLn('FormMouseUp: ', Button, ', ', Shift, ' at ', X, ', ', Y);
end;

procedure DoButtonClick(Sender: TObject);
begin
  WriteLn('Button clicked: ', TLazButton(Sender).GetCaption());

  if (TLazButton(Sender).GetCaption() = 'Close this form') then
    Form.Close();
end;

procedure DoSelectionChange(Sender: TObject; User: Boolean);
begin
  WriteLn('List selection changed to: ', TLazListBox(Sender).GetSelectedText());
end;

procedure ShowMyForm;
var
  Button: TLazButton;
  List: TLazListBox;
  Lbl: TLazLabel;
  Panel: TLazPanel;
begin
  Form := TLazForm.Create();
  Form.SetCaption('Example form');
  Form.SetOnMouseDown(@FormMouseDown);
  Form.SetOnMouseUp(@FormMouseUp);
  Form.SetWidth(700);
  Form.SetHeight(500);
  Form.SetPosition(poScreenCenter);
  Form.SetColor(Colors.DARK_GREY);
  Form.SetBorderStyle(bsSingle); // Do not allow resizing

  Button := TLazButton.Create(Form);
  Button.SetParent(Form);
  Button.SetAutoSize(True);
  Button.SetLeft(300);
  Button.SetTop(50);
  Button.SetShowHint(True);
  Button.SetHint('Mouse over hint');
  Button.SetCaption('This is a button');
  Button.GetFont().SetSize(12);
  Button.SetOnClick(@DoButtonClick);

  Button := TLazButton.Create(Form);
  Button.SetParent(Form);
  Button.SetAutoSize(True);
  Button.SetLeft(300);
  Button.SetTop(100);
  Button.SetCaption('This is a bigger button');
  Button.GetFont().SetSize(18);
  Button.SetOnClick(@DoButtonClick);

  Button := TLazButton.Create(Form);
  Button.SetParent(Form);
  Button.SetAutoSize(True);
  Button.SetLeft(25);
  Button.SetTop(300);
  Button.SetCaption('Close this form');
  Button.GetFont().SetSize(12);
  Button.SetOnClick(@DoButtonClick);

  // Create a panel add a label and listbox in it, which are auto positioned&sized with SetAlign
  Panel := TLazPanel.Create(Form);
  Panel.SetParent(Form);
  Panel.SetBounds(25,25, 250,250);
  Panel.SetBevelOuter(bvNone);

  Lbl := TLazLabel.Create(Panel);
  Lbl.SetParent(Panel);
  Lbl.SetCaption('List box:');
  Lbl.SetAlign(alTop);

  List := TLazListBox.Create(Panel);
  List.SetParent(Panel);
  List.SetAlign(alClient);
  List.GetItems().Add('Item 1');
  List.GetItems().Add('Item 2');
  List.GetItems().Add('Item 3');
  List.SetOnSelectionChange(@DoSelectionChange);

  Form.ShowModal();

  WriteLn('Form has been closed.');
end;

begin
  RunInMainThread(@ShowMyForm);
end.
 h      ˙˙ ˙˙               (                                     ą Ů Ô ÔÔÔÔÔÔÜ                    Ú˙˙˙˙˙˙˙˙ů)                    Ő˙˙˙˙˙˙˙˙Ł                        Ő˙˙˙˙˙˙|˙s˙	q                        Ő˙˙˙˙˙x˙g˙c˙
f                        Ő˙˙˙˙	*y˙	i˙^˙\˙	aŃ   
                     Ő˙˙˙˙
&t˙
*z˙	&u˙	#m˙&m˙=˛4qˇ<~ĘË@ÚÉAăťKëF$Ő!˙˙˙&˙6˙	?˙	G˙	H˙L˙$fś˙6|Ď˙<Ý˙<ŕ˙=á˙FęÄ	C Ő
F˙˙˙˙OŻ˙^ź˙bż˙bż˙eż˙/}×˙8Ý˙7}Ő˙>ă˙Bć˙KíeŐ	E˙1˙˙˙>Ľ˙hÇ˙iĆ˙iČ˙
kČ˙1Ý˙8ă˙1mż˙6oÁS÷FaŹů
Ő˙'˙˙˙5Ą˙gĹ˙hĆ˙hČ˙kĘ˙1ŕ˙7ĺ˙7ĺ˙6ßĺ8ç4    Ő˙˙˙˙.˙eÂ˙oĚ˙oÎ˙lÍ˙*}Ü˙4ç˙5ĺ˙7ä˙>çŤ    Ű˙˙˙˙˙U§˙iš˙}Ń˙aš˙fČ˙kĚ˙'kĘ˙+eÂ˙CuĘz    ˙˙	˙˙˙
5˙F˙@čX˛ŤdĘi\ž7P°kF¤S           V
ň˙˙
˙
˙#ĘAŁ#                                    /˛ÖĘ                                        ?   ?   ?                                   Ŕ˙  	      ˙˙ ˙˙               (      0                               Í Ç Ç Ç Ç ÇÇÇÇÇÇÇÇÉÁ)˘2                            Î˙˙˙˙˙˙˙˙˙˙˙˙˙˙                                Č˙˙˙˙˙˙˙˙˙˙˙˙˙ě
$                                Č˙˙˙˙˙˙˙˙˙˙˙˙˙                                    Č˙˙˙˙˙˙˙˙˙˙˙}˙|˙
zN                                    Č˙˙˙˙˙˙˙˙˙}˙x˙p˙n˙mB                                    Č˙˙˙˙˙˙˙˙˙r˙g˙d˙	f˙hN                                    Č˙˙˙˙˙˙)˙	s˙n˙g˙_˙^˙	a˙	fn                                    Č˙˙˙˙˙˙'{˙
-|˙	l˙b˙]˙\˙	]˙
cŢ_                                Č ˙˙˙˙˙˙q˙+{˙
)y˙
&u˙	!m˙	f˙	c˙!h˙,tÉ&Z +6rś<|Ăľ@Đ˛AŮłCáŽJéZŇüČ 	˙˙˙˙˙˙&u˙%t˙	1˙	4˙
5˙
5˙5˙;˙M˙*e°ö5tŔ˙:~Ď˙=Ű˙>Ţ˙>ŕ˙@ç˙MëČ6˙˙˙˙˙˙=˙	5˙A˙KŁ˙MĽ˙	NĽ˙
N¤˙RĽ˙!gš˙2zÎ˙9Ř˙<ß˙<ŕ˙<á˙=ŕ˙?ĺ˙JěŚ6ĄČX˙2˙˙˙˙
˙:˙Yš˙Xś˙^ť˙_ź˙`ź˙aź˙cź˙*yŇ˙9ß˙9Ý˙9Ţ˙<ä˙=á˙>á˙Dę˙Sď?Č	L˙O˙˙˙˙˙˙Tľ˙eĹ˙fÄ˙gĹ˙gĆ˙hĆ˙iĹ˙-}Ř˙9â˙6Ţ˙+`­˙9wÍřCéĚGěíNď    Č˙K˙@˙˙˙˙˙	FŹ˙hÇ˙hĹ˙iÇ˙iČ˙	jČ˙kČ˙.Ű˙8â˙8ä˙6|Ő˙*Uä6|iş˙i¸ű	    Č	˙˙
6˙˙˙˙
˙>§˙gĹ˙hĹ˙hÇ˙iČ˙	iÉ˙
jÉ˙/Ţ˙7ä˙6ä˙7ç˙7ă˙6ÝÖ<é'        Č˙˙˙˙˙˙˙:Ł˙fĂ˙gĹ˙hĆ˙hČ˙
iÉ˙jĘ˙.ß˙7ç˙5ć˙5ä˙5ă˙8ä˙;čĹGí    Č˙˙˙˙˙˙˙1˙dÁ˙kČ˙sĎ˙nĚ˙kĚ˙kÍ˙ uÔ˙2ć˙3ç˙4ć˙5ă˙8ä˙=číPë    Č˙˙˙˙˙˙˙˙ZŻ˙^ł˙vČ˙"ć˙Ű˙dż˙gÇ˙lÍ˙$oĐ˙+sÓ˙0vŐ˙-jČ˙CvĚŘż˙    	Ď˙˙˙˙˙˙˙˙D˙	O˙
P˙_Ź˙A˙P§˙cÇ˙bĆÓ^żĂVľńMŤ˙!FŁŇ4Y­8        
cŕ˙˙	˙
˙	˙˙˙
˙
E˙E˙<řOŤŚoŃ}dĘ6kŐ
    Yş$!Zş7/cŔ	                ¤	˙˙˙˙
˙
˙
˙
˙(ę>J                                                        
ý˙˙˙˙˙
Ő	+                                                                9ŤĆĹŽ\
                                                         ˙   ˙  ˙  ˙  ˙  ˙  ˙   ˙                                        G ˙ ŕ˙ đ˙ ¨      ˙˙ ˙˙               (       @                               ż š š š š š š ššššššššššššŔ	#$S°                                    Ŕ ˙˙˙˙˙ ˙ ˙˙˙˙˙˙˙˙˙˙˙˙˙ä#Ą"                                        ş˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙o                                            ş˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙á*                                            ş˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙u                                                ş˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙ů$                                                ş˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙y˙v˙vńm                                                ş˙˙˙˙˙˙˙˙˙˙˙˙}˙z˙u˙n˙l˙	méj                                                ş˙˙˙˙˙˙˙˙˙˙˙˙y˙n˙i˙f˙e˙
hôg!                                                ş˙˙˙˙˙˙˙˙˙"z˙	r˙w˙q˙e˙`˙`˙a˙	eřh%                                                ş˙˙˙˙˙˙˙˙!˙1˙
s˙	h˙e˙a˙^˙]˙^˙	b˙fu                                                ş˙˙˙˙˙˙˙˙{˙	.}˙
-|˙
!p˙e˙_˙]˙]˙]˙	_˙
dég+                                            ş ˙˙˙˙˙˙˙˙x˙
$t˙
-}˙
)y˙
'v˙
"p˙i˙d˙	a˙
a˙f˙$mŕ s#;|ź6tˇ<|Â@ËBŇAŮDáIćYkžö    ş ˙˙˙˙˙˙˙˙'{˙m˙+y˙
,|˙
-~˙
.˙
-~˙
,z˙
+u˙,t˙2y˙?˙ QŰ/kłÎ4q¸˙:{Ĺ˙=Ń˙?Ů˙?Ü˙?ß˙?ĺ˙IëÓ\˘ę&ş ˙˙˙˙˙˙˙˙2˙	#s˙'x˙	5˙:˙	<˙	=˙
>˙
>˙@˙E˙T ˙'eł˙0qŔ˙7{Ë˙:Ö˙;Ý˙=ŕ˙=ŕ˙=ŕ˙>â˙Aé˙Nëş4˙	;˙˙˙˙˙˙˙2˙E˙
4˙B˙L¤˙O¨˙PŠ˙	PŠ˙	Q¨˙R§˙VŠ˙fš˙0yÎ˙6Ö˙:Ü˙<ß˙<ŕ˙<ŕ˙<á˙=ŕ˙>á˙Bé˙Pî  şWŁ˙O˙#˙˙˙˙˙˙˙Tł˙Vś˙Tą˙[ˇ˙]ş˙^ş˙^ť˙_ť˙	`ť˙	bť˙$tĚ˙8Ţ˙8Ţ˙:Ţ˙;â˙;â˙;á˙<ŕ˙=ŕ˙?ĺ˙Hěď\˘ďş
N ˙V˙
>˙˙˙˙˙˙	˙	6˙_Â˙aÂ˙cÁ˙eÂ˙eĂ˙eĂ˙fÄ˙	gÄ˙hÂ˙(yÓ˙9á˙8ŕ˙5Ú˙+fˇ˙:ß˙?ć˙@ä˙Ać˙Eë˙Qđ|    ş˙	Q˙U˙,˙˙˙˙˙˙˙Wş˙fĆ˙gĹ˙hĆ˙hĆ˙iÇ˙iÇ˙
jÇ˙jĆ˙*|×˙9ă˙7ŕ˙8ä˙/iˇ˙)G˙<xÎ˝FńfLńSňŠe­đ    ş˙˙M˙K˙˙˙˙˙˙	˙
Nł˙gĆ˙hĹ˙hĆ˙hÇ˙iČ˙iČ˙
jČ˙kÇ˙+}Ů˙8ă˙6á˙8ă˙9ĺ˙0hť˙"D§        ů˙        ş˙˙˙A˙!˙˙˙˙˙˙	G­˙gĹ˙hĹ˙hĆ˙iÇ˙iČ˙	iČ˙
jÉ˙jČ˙,~Ü˙7ä˙5ă˙7ä˙7ć˙8č˙6Ý˙5~Ů˝Bé            ş˙˙˙˙˙˙˙˙˙˙CŞ˙fÄ˙gÄ˙hĹ˙hÇ˙iČ˙	iÉ˙jĘ˙jÉ˙.Ţ˙8ć˙5ĺ˙6ĺ˙6ä˙6ä˙7ĺ˙9ç˙<é˝@č        ş˙˙˙˙˙˙˙˙˙	˙?Ś˙eĂ˙gÄ˙hĹ˙hÇ˙	iČ˙
iÉ˙jĘ˙iĘ˙&zŘ˙7é˙5ç˙4ć˙5ĺ˙5ă˙5á˙7á˙:ç˙?éH        ş˙˙˙˙˙˙˙˙˙˙4˙dŔ˙hÄ˙
oĚ˙vŃ˙oÍ˙kË˙kË˙lÍ˙nÎ˙.â˙3č˙3č˙4ć˙5ä˙6ă˙8ĺ˙<é˙HęZ        ş˙˙˙˙˙˙˙˙˙˙	 ˙\˛˙bš˙f˝˙Ô˙"ĺ˙!ĺ˙|Ý˙gÇ˙hÉ˙lĚ˙"pŃ˙(tŐ˙-yÚ˙2|Ý˙4}Ţ˙0qĎ˙>uÍ˙fĺL        	ť˙˙˙˙˙˙˙˙˙˙˙K˙
S˙H˙]Ź˙×˙mť˙N˙H˙dĆ˙dČ˙aĂ˙^ż˙Zş˙Uł˙ NŹ˙ F˘˙6^˛ Ă˙˙        	ş˙˙˙˙˙	˙˙˙˙˙˙
,˙
T˙	K˙H˙@˙%q˙E˙bĹ˙bÇădĘ°cĹ^aÁfWˇłRąâO­Ń%M¨g-`Ň            1¨ű˙˙	˙
˙
˙
˙˙˙	˙
˙2˙
J˙E˙B˙IŚŠmŃxx×O`Ě
                %pŘCó                            	?ä˙˙˙˙˙˙
˙
˙
˙
˙
˙*ţ=z                                                                        &
Ę˙˙˙˙˙˙˙˙
˙
ó
Q                                                                                ý˙˙˙˙˙˙
Ë	?                                                                                            9¤ľ˛ś
6                                                                          ˙  ˙  ˙  ˙  ˙  ˙  ˙  ˙  ˙  ˙  ˙  ˙                                                   Ŕ ˙ŕ ˙˙đ˙˙ü˙˙¨%      ˙˙ ˙˙               (   0   `                              ^                )ĄE§                                                        ˘ ˙ ˙ ˙ ˙ ˙ ˙ ˙ ˙ ˙ ˙ ˙ ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙ň)ŁF                                                            ˙ ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙üB                                                                ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙Â^Ś                                                                 ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙
#J                                                                    ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙Â<                                                                    ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙	[                                                                        ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˝\Ŕ                                                                        ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙
§                                                                            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙|˙y˙x˙z˙s                                                                            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙~˙y˙u˙q˙q˙r˙o|                                                                            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙~˙{˙y˙v˙r˙n˙k˙k˙m˙k{                                                                            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙w˙q˙m˙j˙g˙f˙f˙	i˙h                                                                            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙}˙x˙}˙˙~˙t˙j˙e˙c˙b˙b˙	c˙	g˙gŠ                                                                            ˙˙˙˙˙˙˙˙˙˙˙˙˙%˙+}˙r˙
o˙	r˙s˙n˙f˙`˙_˙_˙`˙a˙	d˙
fŚ                                                                            ˙˙˙˙˙˙˙˙˙˙˙˙˙%˙3˙
'y˙	n˙	j˙h˙f˙b˙_˙]˙^˙^˙^˙	b˙fęg)                                                                        ˙˙˙˙˙˙˙˙˙˙˙˙˙ x˙1˙
0˙
%v˙	j˙d˙c˙`˙_˙]˙]˙]˙]˙	_˙	d˙	d                                                                        ˙ ˙˙˙˙˙˙˙˙˙˙˙˙p˙	+{˙
0˙	,{˙%u˙	m˙d˙`˙_˙^˙^˙]˙]˙	^˙
b˙
fý!i\                                                                     ˙ ˙˙˙˙˙˙˙˙˙˙˙˙p˙	"r˙
.~˙
-}˙
)y˙
(w˙
%t˙	 m˙	h˙c˙a˙`˙	_˙
_˙b˙f˙!iü$nU        >yˇ/9wťp<}Ăj>ĆkBĚkBĎkBÔkBŮkEŕmKĺ]_¨ŕ	             ˙ ˙˙˙˙˙˙˙˙˙˙˙!˙ s˙
m˙)x˙
-|˙
*z˙
*z˙
*z˙*z˙
(x˙	&t˙	$o˙	"k˙	 i˙
!h˙"j˙&o˙+t˙7úGP1qˇ/2ołç5rˇ˙;zŔ˙=~Č˙@Ď˙@Ó˙A×˙AŰ˙Bß˙Bä˙CćËVĽî{˝ó	     ˙ ˙˙˙˙˙˙˙˙˙˙˙&˙)y˙k˙#s˙
-{˙
-|˙
.~˙
/˙
/˙
/˙
0˙
0˙
/{˙
/y˙0x˙2z˙8˙B˙N˙#XĄř.j˛î1mś˙6sźţ:zĹţ;~Íţ=Őţ>Űţ>Ýţ?Ýţ?Ţţ>á˙=ĺ˙Bë˙Rëľyľí	 ˙˙˙˙˙˙˙˙˙˙˙˙%˙5˙
 p˙p˙,}˙	2˙	5˙	8˙	9˙
:˙
:˙
;˙
;˙
;˙<˙>˙D˙N˙ ZŚ˙(dą˙.mş˙2sÁ˙7yÉ˙9Ň˙:Ů˙<Ý˙=ŕ˙=ŕ˙=ŕ˙=ŕ˙>á˙>ă˙?čţEę˙Wę`˙˙˙˙˙˙˙˙˙˙˙˙	˙<˙3˙#w˙+˙:˙@˙C˙E˙F˙G˙	G˙
G˙
H˙I˙K˙O˙YŠ˙$gˇ˙-qĂ˙2xË˙6~Ň˙:Ř˙<Ü˙<ß˙<ŕ˙<ŕ˙<ŕ˙=á˙=á˙=á˙>â˙Aç˙Fě˙Tíi˙
F˙O˙˙˙˙˙˙˙˙˙˙˙9˙NŤ˙B˙4˙B˙L¤˙OŠ˙QŤ˙RŹ˙SŹ˙	S­˙	T­˙	TŹ˙
UŤ˙VŤ˙ZŽ˙c¸˙+uĘ˙3}Ó˙7Ř˙9Ű˙;Ý˙<ß˙<ŕ˙;ŕ˙;á˙<á˙<á˙=ŕ˙=ŕ˙?â˙@č˙Hěń]¤ď<9¤˙^ ˙T˙8˙˙˙˙˙˙˙˙˙˙	$˙Uľ˙Yš˙O­˙OŤ˙V˛˙Zś˙[ˇ˙\¸˙\¸˙\¸˙]š˙]¸˙	^š˙`š˙aş˙lĂ˙5Ű˙7Ü˙8Ý˙9Ţ˙;ß˙;ŕ˙;ŕ˙;á˙;á˙<ŕ˙<ŕ˙=ŕ˙=ŕ˙?ĺ˙Bę˙Qí§     	BŚ˙`˘˙O˙F˙'˙˙˙˙˙˙˙˙˙˙	>˙^Ŕ˙^ż˙]˝˙^ź˙až˙bż˙bż˙bŔ˙bŔ˙cŔ˙cŔ˙	dŔ˙eŔ˙
fż˙qÉ˙7ŕ˙8ß˙7ß˙8ß˙7Ú˙6Ú˙:ĺ˙;ă˙<â˙=áţ>á˙>â˙@ă˙Aé˙Iîô_ĽđE    ˙V ˙Z˙L˙
>˙˙˙˙˙˙˙˙˙˙	˙Q°˙aÄ˙aĂ˙bÂ˙dÂ˙eĂ˙fÄ˙fÄ˙fÄ˙gĹ˙gĹ˙	hĹ˙
hÄ˙	iĂ˙tÍ˙8á˙8ŕ˙8ß˙7ŕ˙4Ú˙ N˙0kÁ˙=č˙?ć˙Aĺ˙Aĺ˙Aç˙Dę˙Fí˙Tń         ˙%˙	V˙
Y˙N˙	,˙˙˙˙˙˙˙˙˙˙:˙aĹ˙dÄ˙eÄ˙gĹ˙hĹ˙hĆ˙hĆ˙hÇ˙hÇ˙iÇ˙	iÇ˙
kÇ˙	kĆ˙ vĐ˙8ă˙8á˙7ŕ˙7ŕ˙8ĺ˙0oÂ˙ -a˙/Y ˙>ÚöFęˇEě˘FđśOń˙QńźcŹň
        ˙ ˙&˙
T˙Y˙F˙˙˙˙˙˙˙˙˙˙&˙^Â˙fĹ˙gĹ˙hĹ˙hĆ˙iĆ˙iÇ˙iÇ˙iÇ˙	iÇ˙
jČ˙kČ˙	kÇ˙"wÓ˙9ä˙8â˙6á˙7á˙8ă˙:ä˙0fś˙"/a˙#5eŤ            `Ž÷^j¸ű            ˙˙˙$˙O˙V˙
1˙˙˙˙˙˙˙˙˙˙	Y˝˙fĹ˙gĹ˙hĹ˙hĹ˙hĆ˙hÇ˙iČ˙iČ˙	iČ˙
jČ˙kČ˙	kÇ˙#xÔ˙8ä˙7â˙6á˙6â˙8ä˙9ć˙8ä˙3oČ˙&Oń9yO                            ˙˙˙˙˙L ˙A˙˙˙˙˙˙˙˙˙
˙T¸˙fĹ˙hĹ˙hĹ˙hĹ˙hÇ˙iÇ˙iČ˙iČ˙	iČ˙
jÉ˙kÉ˙jČ˙$y×˙7ĺ˙6ă˙5ă˙6ă˙7ä˙7ĺ˙7ć˙8é˙8á˙0sËó/xĐYž                    ˙˙˙˙	˙˙
)˙˙˙˙˙˙˙˙˙	˙Rľ˙fÄ˙gÄ˙gĹ˙hĹ˙hĆ˙hÇ˙iČ˙	iČ˙	iČ˙
jÉ˙kĘ˙	iÉ˙(|Ú˙8ĺ˙6ä˙5ä˙6ä˙6ä˙7ĺ˙7ĺ˙6ĺ˙8çţ:é˙:č˙@ę                    ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙	˙O˛˙eĂ˙gÄ˙gÄ˙gĹ˙hĆ˙hÇ˙iČ˙iÉ˙	iÉ˙jÉ˙kĘ˙iÉ˙(}Ú˙8ç˙6ć˙5ć˙5ĺ˙5ĺ˙6ä˙6ä˙5ă˙5ă˙7ä˙9ć˙;é˙>éb                ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙L°˙dÂ˙fĂ˙gÄ˙hĹ˙iĆ˙iÇ˙	iÉ˙
iÉ˙
iĘ˙jĘ˙jĘ˙jĘ˙uÓ˙6č˙6ç˙6ç˙5ć˙5ć˙5ĺ˙5ä˙5ă˙5á˙5á˙7â˙9ĺ˙<čŃKâ            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙	˙EŞ˙cÁ˙fÂ˙gÄ˙hĆ˙hÇ˙hČ˙iÉ˙
iÉ˙jĘ˙jË˙kË˙kË˙lĚ˙.â˙5é˙4ç˙4ć˙4ć˙4ĺ˙4ä˙4â˙5á˙6á˙8â˙:ć˙>ęĺLč            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙
˙	9 ˙cž˙fÂ˙hĹ˙lĘ˙yÔ˙xÓ˙rĎ˙lĚ˙jË˙kË˙lĚ˙lÍ˙kË˙sŇ˙/ä˙2č˙2č˙3ç˙3ć˙4ä˙5ă˙5â˙6â˙9ć˙:ë˙@ęä\î            ˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙
&˙^ľ˙ež˙fÁ˙
kĆ˙}Ó˙ á˙"â˙!á˙Ţ˙{Ú˙rÖ˙mŃ˙kÍ˙jË˙nÎ˙#tÔ˙)xŮ˙.|Ţ˙1â˙4ĺ˙6ĺ˙7ć˙7ĺ˙5zŮ˙2sÓ˙VÝčľř            
˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙QŁ˙
\Ş˙T˘˙	P˙M˙sĆ˙"é˙%ę˙%é˙#ß˙eŔ˙L˙cĂ˙hË˙fČ˙dĹţcÄţbÂţ cÂ˙$dÄ˙(gĹ˙*hĆ˙(^ť˙$M¨ţ-TŹ˙]Ô                
	˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙<˙Z˙	M˙	L˙H˙^­˙×˙m˝˙N˙2s˙&e˙PŚ˙dÉ˙eÉţcÇ˙aÄ˙`Á˙^ž˙Zş˙UľţOŽ˙HŚţEŁ˙ EĄ˙.Xąłhą˙                 ˙ţ˙˙˙˙˙˙	˙	˙˙˙˙˙˙˙˙	˙T˙	S˙	I˙	I˙
I˙D˙#i˙]˙)u˙Tą˙`Ĺ˙`Ĺ˙bČ˙cÉÖcĆcÄaÁYšßRą˙NŹ˙NŤ˙IŚŰ+RŹFvŮ                    i	˙˙˙˙˙˙˙˙	˙
˙
˙	˙˙˙˙˙	˙	˙)˙	V˙O˙F˙D˙C˙B˙A˙Zş˙pŃ˙kËż`ÇejŃbm×            Zť^Ŕ[^Áf)aż_1gČ                                 0	ř˙ţ˙	˙	˙
˙
˙
˙
˙
˙˙˙˙	˙	˙
˙'˙
H˙J˙DţC˙DĺTľ\ qÚ7~Ý7ę                                                                                    +Í˙ţ
˙˙˙˙˙
˙˙˙	˙	˙
˙
˙
˙
˙
˙
(˙0˙;ŇQ§5                                                                                                        ť˙
˙˙˙˙˙˙˙˙˙˙
˙
˙
˙
˙
˙	˙
´	 [                                                                                                                !

˙˙˙˙˙˙˙˙˙˙˙˙˙˙
˙
                                                                                                                                kń˙˙˙˙˙˙˙˙˙˙˙
ů	                                                                                                                                        *Şó˙˙˙˙˙˙ö
Ě
*                                                                                                                                                    9F                                                                                                                            ?˙      ˙      ˙˙      ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙     ˙˙      Ŕ                                                                          ç                                                                                   p    ˙˙  ŕ  ?˙˙  đ  ˙˙  ř ˙˙˙  ţ ˙˙˙  ˙ ˙˙˙  ˙Ŕ?˙˙˙  
unit updateform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, updater;

type

  { TSimbaUpdateForm }

  { TSimbaVersionThread }

  TSimbaVersionThread = class(TThread)
  public
    ResultStr : string;
    InputURL : string;
    Done : boolean;
    procedure Execute; override;
  end;
  TSimbaUpdateForm = class(TForm)
    UpdateLog: TMemo;
    UpdateButton: TButton;
    OkButton: TButton;
    CancelButton: TButton;
    DownloadProgress: TProgressBar;
    procedure CancelButtonClick(Sender: TObject);
    procedure CleanUpdateForm(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    function CanUpdate: Boolean;

  private
    { private declarations }

    Updater: TMMLFileDownloader;
    FCancelling: Boolean;
    FSimbaVersion: Integer;
    SimbaVersionThread : TSimbaVersionThread;
  private
    function OnUpdateBeat: Boolean;
    function GetLatestSimbaVersion: Integer;
  public
    { public declarations }
    procedure PerformUpdate;
  protected
    FCancelled: Boolean;
  end; 


var
  SimbaUpdateForm: TSimbaUpdateForm;

implementation

uses
  internets,  TestUnit, simbasettings;

function TSimbaUpdateForm.CanUpdate: Boolean;
begin
  GetLatestSimbaVersion;

  Writeln('Latest Simba Version: ' + IntToStr(FSimbaVersion));
  Exit(testunit.SimbaVersion < FSimbaVersion);
end;

function TSimbaUpdateForm.GetLatestSimbaVersion: Integer;
var
  saveAfterSetting: Boolean = false;
begin
  if SimbaVersionThread = nil then//Create thread (only if no-other one is already running)
  begin
    SimbaVersionThread := TSimbaVersionThread.Create(true);

    if not SettingsForm.Settings.KeyExists('Settings/Updater/RemoteVersionLink') then
      saveAfterSetting := true;

    SimbaVersionThread.InputURL := SettingsForm.Settings.GetSetDefaultKeyValue(
                'Settings/Updater/RemoteVersionLink',
                'http://old.villavu.com/merlijn/Simba'{$IFDEF WINDOWS} +
                '.exe'{$ENDIF} + '.version');

    if saveAfterSetting then
      SettingsForm.Settings.SaveToXML(SimbaSettingsFile);


   // SimbaVersionThread.InputURL:= 'http://old.villavu.com/merlijn/Simba'{$IFDEF WINDOWS} +'.exe'{$ENDIF} + '.version';
    SimbaVersionThread.Resume;
    while SimbaVersionThread.Done = false do//Wait till thread is done
    begin
      Application.ProcessMessages;
      Sleep(50);
    end;
    FSimbaVersion := StrToIntDef(Trim(SimbaVersionThread.ResultStr), -1);//Read output
    FreeAndNil(SimbaVersionThread);//Free the thread
  end else
    //Another thread is already running, lets wait for it! (When it's nil, it means that the result is written!)
    while SimbaVersionThread = nil do
    begin;
      Application.ProcessMessages;
      Sleep(50);
    end;
  Exit(FSimbaVersion);
end;

procedure TSimbaUpdateForm.UpdateButtonClick(Sender: TObject);
begin
  Self.PerformUpdate;
end;

procedure TSimbaUpdateForm.CancelButtonClick(Sender: TObject);
begin
  if FCancelled then
  begin
    Self.ModalResult:=mrCancel;
    Self.Hide;
  end else
  begin
    FCancelling := True;
  end;
end;

procedure TSimbaUpdateForm.CleanUpdateForm(Sender: TObject);
begin
  Self.DownloadProgress.Position:=0;
  Self.UpdateLog.Clear;
  Self.UpdateLog.Lines.Add('---------- Update Session ----------');
end;

procedure TSimbaUpdateForm.OkButtonClick(Sender: TObject);
begin
  Self.ModalResult:=mrOK;
  Self.Hide;
end;

{ Return true if we have to cancel }
function TSimbaUpdateForm.OnUpdateBeat: Boolean;
var
  Percentage: Integer;
begin
  Application.ProcessMessages;

  Percentage := Updater.GetPercentage();
  if Percentage <> -1 then
    DownloadProgress.Position:=Percentage;

  Result := FCancelling;
end;

procedure TSimbaUpdateForm.PerformUpdate;
var
  saveAfterSetting: Boolean = false;
begin
  Updater := TMMLFileDownloader.Create;

  FCancelling := False;
  FCancelled := False;

  // Make this a setting later

  if not SettingsForm.Settings.KeyExists('Settings/Updater/RemoteLink') then
    saveAfterSetting := true;

  Updater.FileURL := SettingsForm.Settings.GetSetDefaultKeyValue(
        'Settings/Updater/RemoteLink',
        'http://old.villavu.com/merlijn/Simba'{$IFDEF WINDOWS} +'.exe'{$ENDIF}
  );

  if saveAfterSetting then
    SettingsForm.Settings.SaveToXML(SimbaSettingsFile);

  //ApplicationName{$IFDEF WINDOWS} +'.exe'{$ENDIF};

  // Should work on Windows as well
  Updater.ReplacementFile := ExtractFileName(Application.ExeName);
  Updater.OnBeat := @Self.OnUpdateBeat;
  Updater.BasePath := ExtractFilePath(Application.ExeName);

  Self.UpdateLog.Lines.Add('Starting download of ' + Updater.FileURL + ' ...');
  try
    Updater.DownloadAndSave;
    Self.UpdateLog.Lines.Add('Downloaded to ' + Updater.ReplacementFile + '_ ...');
    Updater.Replace;
    Self.UpdateLog.Lines.Add('Renaming ' + Updater.ReplacementFile + ' to ' + Updater.ReplacementFile + '_old_');
    Self.UpdateLog.Lines.Add('Renaming ' + Updater.ReplacementFile + '_ to ' + Updater.ReplacementFile);
    Self.UpdateLog.Lines.Add('Deleting ' + Updater.ReplacementFile + '_old_');
    Updater.Free;
  except
    FCancelling := False;
    FCancelled := True;
    Self.UpdateLog.Lines.Add('Download stopped ...');
    // more detailed info
    writeln('EXCEPTION IN UPDATEFORM: We either hit Cancel, or something went wrong with files');
  end;
  Self.UpdateLog.Lines.Add('Done ... ');
  Self.UpdateLog.Lines.Add('Please restart all currently running Simba binaries.');
end;

{ TSimbaVersionThread }

procedure TSimbaVersionThread.Execute;
begin
  ResultStr:= GetPage(InputURL);
  done := true;
end;

initialization
  {$I updateform.lrs}

end.


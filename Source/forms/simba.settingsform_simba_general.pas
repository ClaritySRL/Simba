{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.settingsform_simba_general;

{$i simba.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls, Spin,
  DividerBevel;

type
  TSimbaGeneralFrame = class(TFrame)
    OutputFontAntiAliased: TCheckBox;
    OutputFontName: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    OutputDivider: TDividerBevel;
    MacOSCommandKey: TCheckBox;
    ExtractOpenSSLCheckbox: TCheckBox;
    GeneralDivider: TDividerBevel;
    OutputFontSize: TSpinEdit;
    ToolbarSizeCaption: TLabel;
    FontSizeLabel: TLabel;
    ToolbarSizeTrackBar: TTrackBar;
    FontSizeTrackBar: TTrackBar;

    procedure FontSizeTrackBarChange(Sender: TObject);
    procedure ToolbarSizeTrackBarChange(Sender: TObject);
  public
  end;

implementation

{$R *.lfm}

procedure TSimbaGeneralFrame.FontSizeTrackBarChange(Sender: TObject);
begin
  if (FontSizeTrackBar.Position = FontSizeTrackBar.Min) then
    FontSizeLabel.Caption := 'Font Size (Default)'
  else
    FontSizeLabel.Caption := 'Font Size (' + IntToStr(FontSizeTrackBar.Position) + ')';
end;

procedure TSimbaGeneralFrame.ToolbarSizeTrackBarChange(Sender: TObject);
begin
  if (ToolbarSizeTrackBar.Position = ToolbarSizeTrackBar.Min) then
    ToolbarSizeCaption.Caption := 'Toolbar Size (Default)'
  else
    ToolbarSizeCaption.Caption := 'Toolbar Size (' + IntToStr(ToolbarSizeTrackBar.Position) + ')';
end;

end.


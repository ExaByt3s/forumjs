unit UfrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.TabControl, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmMain = class(TForm)
    lyMainLayout: TLayout;
    tbMain: TTabControl;
    tbiLogin: TTabItem;
    tbiApplication: TTabItem;
    lyLeft: TLayout;
    lyRight: TLayout;
    LangGlobal: TLang;
    lyContentLog: TLayout;
    btnStartSession: TButton;
    txtUsername: TEdit;
    txtPassword: TEdit;
    lblSignUp: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

end.

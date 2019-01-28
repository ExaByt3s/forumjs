unit UViewApp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl,
  // view mgr
  UViewMgr,
  // microservice
  UDMServer;

type
  TfrmApp = class(TForm)
    lyViewApp: TLayout;
    tbMainApp: TTabControl;
    tbiPortal: TTabItem;
    TabItem2: TTabItem;
    lyViewArticle: TLayout;
    rctBoard: TRectangle;
    crlProfilePhoto: TCircle;
    btnlogout: TButton;
    lblnickname: TLabel;
    procedure btnlogoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.fmx}

procedure TfrmApp.btnlogoutClick(Sender: TObject);
begin
  viewMgr.LaunchView(TViewType.LOGOUT_SESSION);
end;

procedure TfrmApp.FormCreate(Sender: TObject);
begin
  crlProfilePhoto.Fill.Bitmap.Bitmap := dmData.User.Image;
  lblnickname.Text := dmData.User.Nickname;
end;

end.

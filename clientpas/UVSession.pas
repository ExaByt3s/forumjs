unit UVSession;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Objects,
  // Manager
  UViewMgr,
  // Controllers
  UCSession;

type
  TfrmVSession = class(TForm)
    lyVSession: TLayout;
    tbSession: TTabControl;
    tbiLogIn: TTabItem;
    tbiSignIn: TTabItem;
    rctLogPanel: TRectangle;
    txtnickname_l: TEdit;
    txtpassword_l: TEdit;
    btnstartsession: TButton;
    lblgotosignin: TLabel;
    rctSignPanel: TRectangle;
    txtnickname_s: TEdit;
    txtemail_s: TEdit;
    btnregister: TButton;
    lblgotologin: TLabel;
    txtpasscon_s: TEdit;
    txtpass_s: TEdit;
    Layout1: TLayout;
    txtfn_s: TEdit;
    txtln_s: TEdit;
    crlPhoto: TCircle;
    odLoadPhoto: TOpenDialog;
    btnloadphoto: TButton;
    lyLoading: TLayout;
    rctLoadingBase: TRectangle;
    AniIndicator1: TAniIndicator;
    procedure lblgotosigninClick(Sender: TObject);
    procedure btnstartsessionClick(Sender: TObject);
    procedure btnregisterClick(Sender: TObject);
    procedure lblgotologinClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnloadphotoClick(Sender: TObject);
    procedure crlPhotoMouseEnter(Sender: TObject);
    procedure crlPhotoMouseLeave(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ADefaultStreamImg: TBytesStream;
  public


    // closure
    procedure Loading(AActive: Boolean);
    procedure ClearController(AInReturn: Boolean);
  end;

var
  frmVSession: TfrmVSession;

implementation

{$R *.fmx}

procedure TfrmVSession.FormCreate(Sender: TObject);
begin
  { Tricks }
  // txtnickname_l.SetFocus; BUG.

  { Settings }
  ADefaultStreamImg := TBytesStream.Create;
  crlPhoto.Fill.Bitmap.Bitmap.SaveToStream(ADefaultStreamImg);

  { closure }
  gViewMgr.Loading := Loading;
  CSession.ClearController := ClearController;
  CSession.ChangeFrontTab := lblgotologinClick;
end;

procedure TfrmVSession.FormDestroy(Sender: TObject);
begin
  ADefaultStreamImg.Free;

  { Disable owned closure }
  gViewMgr.Loading := nil;
end;

procedure TfrmVSession.btnstartsessionClick(Sender: TObject);
begin
  CSession.LogIn(txtnickname_l.Text, txtpassword_l.Text);
end;

procedure TfrmVSession.btnregisterClick(Sender: TObject);
var
  stream: TBytesStream;
begin
  stream := TBytesStream.Create;
  crlPhoto.Fill.Bitmap.Bitmap.SaveToStream(stream);
  CSession.SignIn(txtnickname_s.Text, txtln_s.Text, txtfn_s.Text,
                  txtemail_s.Text, txtpasscon_s.Text, stream);
end;

procedure TfrmVSession.lblgotosigninClick(Sender: TObject);
begin
  tbSession.GotoVisibleTab(1, TTabTransition.Slide);
  txtnickname_s.SetFocus;
  ClearController(False);
end;

procedure TfrmVSession.lblgotologinClick(Sender: TObject);
begin
  tbSession.GotoVisibleTab(0, TTabTransition.Slide);
  txtnickname_l.SetFocus;
  ClearController(False);
end;

procedure TfrmVSession.btnloadphotoClick(Sender: TObject);
begin
  odLoadPhoto.Filter := TBitmapCodecManager.GetFilterString;
  if odLoadPhoto.Execute then
  begin
    crlPhoto.Fill.Bitmap.Bitmap.LoadFromFile(odLoadPhoto.FileName);
  end;
  crlPhotoMouseLeave(nil);
end;

procedure TfrmVSession.crlPhotoMouseEnter(Sender: TObject);
begin
  btnloadphoto.Visible := True;
end;

procedure TfrmVSession.crlPhotoMouseLeave(Sender: TObject);
begin
  btnloadphoto.Visible := False;
end;

procedure TfrmVSession.Loading(AActive: Boolean);
begin
  lyLoading.Visible := AActive;
  AniIndicator1.Enabled := AActive;
end;

procedure TfrmVSession.ClearController(AInReturn: Boolean);
begin
  if AInReturn then
  begin
    txtpassword_l.Text := '';
    txtpass_s.Text := '';
    txtpasscon_s.Text := '';
    txtnickname_s.Text := '';
  end
  else
  begin
    txtnickname_l.Text := '';
    txtpassword_l.Text := '';
    txtnickname_s.Text := '';
    txtln_s.Text := '';
    txtfn_s.Text := '';
    txtemail_s.Text := '';
    txtpass_s.Text := '';
    txtpasscon_s.Text := '';
    crlPhoto.Fill.Bitmap.Bitmap.LoadFromStream(ADefaultStreamImg);
  end;
end;

end.

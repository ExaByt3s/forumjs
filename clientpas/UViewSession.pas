unit UViewSession;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.TabControl, FMX.Objects,
  UExceptionHandler,
  // Controller
  UCSession,
  // mgr view
  UViewLoading,
  UViewMgr,
  // microservice
  UDMServer;

type
  TfrmViewSession = class(TForm)
    lyViewSession: TLayout;
    tbMainSession: TTabControl;
    tbiLogin: TTabItem;
    tbiSignin: TTabItem;
    lyPanelLogin: TLayout;
    txtusername: TEdit;
    txtpassword: TEdit;
    btnstartsession: TButton;
    lblsignin: TLabel;
    lyPanelSignin: TLayout;
    txtusername_s: TEdit;
    txtfn_s: TEdit;
    txtln_s: TEdit;
    txtemail_s: TEdit;
    txtpass_s: TEdit;
    txtpassconfirm_s: TEdit;
    Layout1: TLayout;
    btnsignin: TButton;
    lbllogin: TLabel;
    crlProfilePhoto: TCircle;
    lyPanelLeft: TLayout;
    odLoadPhoto: TOpenDialog;
    lyLoading: TLayout;
    procedure lblsigninClick(Sender: TObject);
    procedure lblloginClick(Sender: TObject);
    procedure crlProfilePhotoClick(Sender: TObject);
    procedure btnstartsessionClick(Sender: TObject);
    procedure btnsigninClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FActiveForm: TForm;
    FExh: TExceptionHandler;
  public
    // Loading
    procedure Loading(active: Boolean);
  end;

var
  frmViewSession: TfrmViewSession;

implementation

{$R *.fmx}

procedure TfrmViewSession.btnsigninClick(Sender: TObject);
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
    procedure
    var
      ex: TExceptionHandler;
    begin
      ex := cSession.RegisterUser(txtusername_s.Text, txtfn_s.Text,
        txtln_s.Text, txtemail_s.Text, txtpass_s.Text, crlProfilePhoto.Fill.Bitmap.Bitmap);
      TThread.Sleep(1000);
      TThread.Synchronize(TThread.Current,
        procedure
        begin
          if ex.Response then
          begin
            Loading(False);
            ex.DisposeOf;
            lblloginClick(nil)
          end
          else
            viewMgr.PromptMsg(FExh.ProcessCodError);
        end
      );
    end
  );
  th.FreeOnTerminate := True;
  Loading(True);
  th.Start;
end;

procedure TfrmViewSession.btnstartsessionClick(Sender: TObject);
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
    procedure
    var
      ex: TExceptionHandler;
    begin
      ex := cSession.StartSession(txtusername.Text, txtpassword.Text);
      TThread.Sleep(1000);
      TThread.Synchronize(TThread.Current,
        procedure
        begin
          Loading(False);
          if ex.Response then
          begin
            ex.DisposeOf;
            viewMgr.LaunchView(TViewType.START_SESSION);
          end
          else
            viewMgr.PromptMsg(FExh.ProcessCodError);
        end
      );
    end
  );
  th.FreeOnTerminate := True;
  Loading(True);
  th.Start;
end;

procedure TfrmViewSession.crlProfilePhotoClick(Sender: TObject);
begin
  odLoadPhoto.Filter := TBitmapCodecManager.GetFilterString;
  if odLoadPhoto.Execute then
  begin
    crlProfilePhoto.Fill.Bitmap.Bitmap.LoadFromFile(odLoadPhoto.FileName);
  end;
end;

procedure TfrmViewSession.FormCreate(Sender: TObject);
begin
  FActiveForm := nil;
  GetViews(TfrmLoading, lyLoading, FActiveForm, 'lyLoading1');
end;

procedure TfrmViewSession.lblloginClick(Sender: TObject);
begin
  tbMainSession.Previous();
end;

procedure TfrmViewSession.lblsigninClick(Sender: TObject);
begin
  tbMainSession.Next();
end;

procedure TfrmViewSession.Loading(active: Boolean);
begin
  lyLoading.Visible := active;
end;

end.

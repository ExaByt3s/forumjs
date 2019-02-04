unit UVFrontend;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  // Helper
  UHelper,
  USynchronizer,
  // Manager
  UViewMgr,
  // View
  UVBoards,
  // Controller
  UCFrontend;

type
  TfrmVFrontend = class(TForm)
    lyVFrontend: TLayout;
    rctDashboard: TRectangle;
    crlPhoto: TCircle;
    btnloadphoto: TButton;
    lblnickname: TLabel;
    btnlogout: TButton;
    odloadphoto: TOpenDialog;
    lyBoardView: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnlogoutClick(Sender: TObject);
    procedure crlPhotoMouseEnter(Sender: TObject);
    procedure crlPhotoMouseLeave(Sender: TObject);
    procedure btnloadphotoClick(Sender: TObject);
  private
    FActiveForm: TForm;
  public
    procedure InitSetting;
  end;

var
  frmVFrontend: TfrmVFrontend;

implementation

{$R *.fmx}

procedure TfrmVFrontend.FormCreate(Sender: TObject);
begin
  { Settings }
  InitSetting;

  btnloadphoto.OnMouseEnter := crlPhotoMouseEnter;

  { Get view }
  gViewMgr.GetView(TfrmVBoards, lyBoardView, FActiveForm, nil, 'lyBViews');
end;

procedure TfrmVFrontend.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TfrmVFrontend.InitSetting;
var
  nickname: string;
  stream: TBytesStream;
begin
  BeginRead(TMREWS_CFrontend);
  CFrontend.GetSetting(nickname, stream);
  EndRead(TMREWS_CFrontend);
  crlPhoto.Fill.Bitmap.Bitmap.LoadFromStream(stream);
  lblnickname.Text := nickname;
  stream.Free;
end;

procedure TfrmVFrontend.btnloadphotoClick(Sender: TObject);
begin
  odloadphoto.Filter := TBitmapCodecManager.GetFilterString;
  if odloadphoto.Execute then
  begin
    crlPhoto.Fill.Bitmap.Bitmap.LoadFromFile(odloadphoto.FileName);
    // call update photo into server.
  end;
end;

procedure TfrmVFrontend.btnlogoutClick(Sender: TObject);
begin
  gViewMgr.LaunchView(TViewType.vtLogout);
end;

procedure TfrmVFrontend.crlPhotoMouseEnter(Sender: TObject);
begin
  btnloadphoto.Visible := True;
end;

procedure TfrmVFrontend.crlPhotoMouseLeave(Sender: TObject);
begin
  btnloadphoto.Visible := False;
end;

end.

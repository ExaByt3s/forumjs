unit UViewApp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl,
  UExceptionHandler,
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
    procedure CallAsync;
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.fmx}

procedure TfrmApp.btnlogoutClick(Sender: TObject);
begin
  viewMgr.LaunchView(TViewType.LOGOUT_SESSION);
end;

procedure TfrmApp.CallAsync;
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
    procedure
    var
      stream: TBytesStream;
      bytes: TBytes;
      bmp: TBitmap;
    begin
      stream := TBytesStream.Create(bytes);
      dmData.GetUserPhoto(dmData.User.Id, stream);

      TThread.Sleep(500);

      TThread.Synchronize(TThread.Current,
        procedure
        begin
          // put name
          lblnickname.Text := dmData.User.Nickname;
          bmp := TBitmap.Create;
          bmp.LoadFromStream(stream);
          // Falta gestionar por si ocurre algun error.
          crlProfilePhoto.Fill.Bitmap.Bitmap := bmp
        end
      );
      bmp.Free;
      stream.Free;
    end
  );
  th.FreeOnTerminate := True;
  th.Start;
end;

procedure TfrmApp.FormCreate(Sender: TObject);
begin
  CallAsync;
end;

end.

unit UfrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  // Helpers
  UHelper,
  USynchronizer,
  // Microservices
  UMSCommon,
  UMSServer,
  UMSNotify,
  // Models
  UMUser,
  // Views
  UVSession,
  UVFrontend,
  // Controllers
  UCSession,
  UCFrontend,
  UCBoard,
  // Managers
  UViewMgr;

type
  TfrmMain = class(TForm)
    lyMainPortView: TLayout;
    lyPrompt: TLayout;
    rctBackground: TRectangle;
    rctPanel: TRectangle;
    lblPromptMessage: TLabel;
    btnPromptOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPromptOKClick(Sender: TObject);
  private
    FActiveForm: TForm;
  public

    // closure
    procedure CLPromptMessage(const AMessage: string);
    procedure CLLaunchView(AViewType: TViewType);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  { Initialize Microservices }
  MSCommon := TMSCommon.Create;
  MSServer := TMSServer.Create;
  MSNotify := TMSNotify.Create; // This is a thread.

  { Initialize Managers }
  gViewMgr := TViewMgr.Create;
    { Set closure }
  gViewMgr.LaunchView := CLLaunchView;
  gViewMgr.PromptMessage := CLPromptMessage;

  { Settings }
  lyMainPortView.SetFocus;

  { Initialize Controllers }
  CSession := TCSession.Create;
  CFrontend := TCFrontend.Create;
  CBoard := TCBoard.Create;
  { Set closure to microservices }
  MSNotify.SendNotify := CBoard.ReceivedNotification;

  { Getting Begin View }
  gViewMgr.GetView(TfrmVSession, lyMainPortView, FActiveForm, nil, 'lyVSession');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  { Destructing Microservices }
  MSNotify.Destroy;
  MSServer.Destroy;
  MSCommon.Destroy;

  { Destructing Controllers }
  CSession.Destroy;
  CFrontend.Destroy;
  CBoard.Destroy;

  { Destructing Managers }
  gViewMgr.Destroy;
end;

procedure TfrmMain.btnPromptOKClick(Sender: TObject);
begin
  lyPrompt.Visible := False;
  lblPromptMessage.Text := '';
end;

procedure TfrmMain.CLPromptMessage(const AMessage: string);
begin
  lblPromptMessage.Text := AMessage;
  lyPrompt.Visible := True;
end;

procedure TfrmMain.CLLaunchView(AViewType: TViewType);
begin
  case AViewType of
    vtStartSession:
    begin
      { Started Microservice Notify }
      BeginRead(TMREWS_gMUser);
      MSNotify.CurrentId := gMUser.Id;
      MSNotify.CurrentToken := gMUser.Token;
      EndRead(TMREWS_gMUser);
      MSNotify.Start;

      { Launch view }
      gViewMgr.GetView(TfrmVFrontend, lyMainPortView, FActiveForm, nil, 'lyVFrontend');
    end;
    vtLogout:
    begin
      ResetMicroservice(MSNotify);
      MSServer.ResetMicroservice;

      { Launch view }
      gViewMgr.GetView(TfrmVSession, lyMainPortView, FActiveForm, nil, 'lyVSession');
    end;
  end;
end;

end.

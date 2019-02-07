unit UfrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  // Helpers
  UHelper,
  USynchronizer,
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
  { Initialize Managers }
  gViewMgr := TViewMgr.Create;
    { Set closure }
  gViewMgr.LaunchView := CLLaunchView;
  gViewMgr.PromptMessage := CLPromptMessage;

  { Initialize Globals }
  gMUser := TMUser.Create(True);

  { Settings }
  lyMainPortView.SetFocus;

  { Initialize Controllers }
  CSession := TCSession.Create;
  CFrontend := TCFrontend.Create;
  CBoard := TCBoard.Create;
  { Set closure to microservices }

  { Getting Begin View }
  gViewMgr.GetView(TfrmVSession, lyMainPortView, FActiveForm, nil, 'lyVSession');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  { Destructing Controllers }
  CSession.Destroy;
  CFrontend.Destroy;
  CBoard.Destroy;

  { Destructing globals }
  gMUser.Destroy;

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
      { Launch view }
      gViewMgr.GetView(TfrmVFrontend, lyMainPortView, FActiveForm, nil, 'lyVFrontend');
    end;
    vtLogout:
    begin
      ResetUserSession(gMUser);
      { Launch view }
      gViewMgr.GetView(TfrmVSession, lyMainPortView, FActiveForm, nil, 'lyVSession');
    end;
  end;
end;

end.

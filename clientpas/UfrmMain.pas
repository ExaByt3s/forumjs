unit UfrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  UUtilities,
  // Controller
  UCSession,
  // Views
  UViewMgr,
  UViewSession,
  UViewApp,
  // Microservices
  UDMServer, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects;

type
  TfrmMain = class(TForm)
    lyMainView: TLayout;
    lyPrompt: TLayout;
    rctBackground: TRectangle;
    rctPanel: TRectangle;
    lblpromptmsg: TLabel;
    btnokprompt: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnokpromptClick(Sender: TObject);
  private
    FActiveForm: TForm;
    { Private declarations }
  public

    // closures
    procedure PromptCallable(const msg: string);
    procedure LaunchViewCallabe(viewtype: TViewType);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.btnokpromptClick(Sender: TObject);
begin
  lyPrompt.Visible := False;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FActiveForm := nil;
  // microservice
  dmData := TdmData.Create(Self);
  // controller
  cSession := TCSession.Create;
  // view manager
  viewMgr := TViewMgr.Create;
  viewMgr.PromptMsg := PromptCallable;
  viewMgr.LaunchView := LaunchViewCallabe;
  // call default view
  GetViews(TfrmViewSession, lyMainView, &FActiveForm, 'lyViewSession');
end;

procedure TfrmMain.LaunchViewCallabe(viewtype: TViewType);
begin
  case viewtype of
    START_SESSION:
      begin
        GetViews(TfrmApp, lyMainView, FActiveForm, 'lyViewApp');
      end;
    LOGOUT_SESSION:
      begin
        dmData.DisposeOf;
        dmData := nil;
        dmData := TdmData.Create(Self);
        GetViews(TfrmViewSession, lyMainView, FActiveForm, 'lyViewSession');
      end;
  end;
end;

procedure TfrmMain.PromptCallable(const msg: string);
begin
  lblpromptmsg.Text := msg;
  lyPrompt.Visible := True;
end;

end.

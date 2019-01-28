program clientpas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  UDMServer in 'UDMServer.pas' {dmData: TDataModule},
  UModels in 'UModels.pas',
  UUtilities in 'UUtilities.pas',
  UViewSession in 'UViewSession.pas' {frmViewSession},
  UHelper in 'UHelper.pas',
  UExceptionHandler in 'UExceptionHandler.pas',
  UViewMgr in 'UViewMgr.pas',
  UViewApp in 'UViewApp.pas' {frmApp},
  UCSession in 'UCSession.pas',
  UViewLoading in 'UViewLoading.pas' {frmLoading};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLoading, frmLoading);
  Application.Run;
end.

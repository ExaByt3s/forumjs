program ForumDevV2;

uses
  System.StartUpCopy,
  FMX.Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  UViewMgr in 'UViewMgr.pas',
  UMUser in 'UMUser.pas',
  UVSession in 'UVSession.pas' {frmVSession},
  UExceptHandler in 'UExceptHandler.pas',
  UHelper in 'UHelper.pas',
  UCSession in 'UCSession.pas',
  UVFrontend in 'UVFrontend.pas' {frmVFrontend},
  UCFrontend in 'UCFrontend.pas',
  UMArticle in 'UMArticle.pas',
  UVBoards in 'UVBoards.pas' {frmVBoards},
  UCBoard in 'UCBoard.pas',
  UMNotification in 'UMNotification.pas',
  USynchronizer in 'USynchronizer.pas',
  UServerMethods in 'UServerMethods.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

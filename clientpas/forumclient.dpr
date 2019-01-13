program forumclient;



uses
  System.StartUpCopy,
  FMX.Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  UDataModule in 'controller\UDataModule.pas' {dmData: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmData, dmData);
  Application.Run;
end.

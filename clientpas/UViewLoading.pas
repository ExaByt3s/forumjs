unit UViewLoading;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.StdCtrls, FMX.Objects;

type
  TfrmLoading = class(TForm)
    lyViewLoading: TLayout;
    tcMainLoading: TTabControl;
    tbiLoad1: TTabItem;
    lyLoading1: TLayout;
    rctBackground: TRectangle;
    AniIndicator1: TAniIndicator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLoading: TfrmLoading;

implementation

{$R *.fmx}

end.

unit UMisc;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  FMX.StdCtrls, FMX.Graphics, FMX.Objects, FMX.Types;

type
  { Esto es para el loading [Funcionando] 0..100 and Parent }
  TMiscLoading = class(TRectangle)
    private
      FProgressValue: Single;
      FAutodestroy: Boolean;
    public
      constructor Create(AOwner: TComponent; ARelease: Boolean);
      destructor Destroy; virtual;

      { Visualization }
      procedure Setting;

      { Reaction methods }
      procedure SetPValue(AValue: Single);
      procedure Stop;

      property ProgressValue: Single read FProgressValue write SetPValue;
      property Autorelease: Boolean read FAutodestroy write FAutodestroy;
  end;

implementation

{ TMiscLoading }

constructor TMiscLoading.Create(AOwner: TComponent; ARelease: Boolean);
begin
  FProgressValue := 0.0;
  FAutodestroy := ARelease;
  inherited Create(AOwner);
  Setting;
end;

destructor TMiscLoading.Destroy;
begin
  inherited;
end;

procedure TMiscLoading.Setting;
begin
  Align := TAlignLayout.Top;  // Para posicionarlo arriba
  XRadius := 10.0;
  YRadius := 10.0;
  Height := 10.0;
  Fill.Color := $FF11CE00;  // verde R(17) G(206) B(0)
  Stroke.Kind := TBrushKind.None;
  Margins.Right := TRectangle(Owner).Height;

  TRectangle(Owner).AddObject(TFmxObject(Self));
end;

procedure TMiscLoading.SetPValue(AValue: Single);
var
  calculate, owidth: Single;
begin
  if AValue > 100.0 then FProgressValue := 100.0
  else if AValue < 0.0 then FProgressValue := 0.0;
  owidth := TRectangle(Owner).Width;
  FProgressValue := AValue;
  calculate := owidth - (FProgressValue * owidth / 100.0);
  Margins.Right :=  calculate;
  if FAutodestroy and (FProgressValue = 100.0) then
  begin
    Parent := nil;
    Destroy;
  end;
end;

procedure TMiscLoading.Stop;
begin
  SetPValue(100.0);
end;

end.

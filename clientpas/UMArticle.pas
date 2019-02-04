unit UMArticle;

interface

uses
  System.Classes, System.SysUtils;

type
  TMArticle = class(TObject)
    private
      FId: Integer;
      FOwner: Integer;
      FRange: Integer;
      FTitle: string;
      FDesc: string;
      FStreamImg: TBytesStream;

    public
      constructor Create;
      destructor Destroy; virtual;

      procedure CopyImg(AStream: TBytesStream);

      property Id: Integer read FId write FId;
      property Owner: Integer read FOwner write FOwner;
      property Range: Integer read FRange write FRange;
      property Title: string read FTitle write FTitle;
      property Description: string read FDesc write FDesc;
      property StreamImg: TBytesStream read FStreamImg write CopyImg;
  end;

implementation

{ TMArticle }

constructor TMArticle.Create;
begin
  FId := 0;
  FOwner := 0;
  FRange := 0;
  FTitle := '';
  FDesc := '';
  FStreamImg := nil;
  inherited;
end;

destructor TMArticle.Destroy;
begin
  if Assigned(FStreamImg) then FStreamImg.Free;
  inherited;
end;

procedure TMArticle.CopyImg(AStream: TBytesStream);
begin
  if not Assigned(FStreamImg) then
  begin
    FStreamImg := TBytesStream.Create;
    FStreamImg.Clear;
    FStreamImg.CopyFrom(AStream, AStream.Size);
  end
  else
  begin
    FStreamImg.Clear;
    FStreamImg.CopyFrom(AStream, AStream.Size);
  end;
end;

end.

unit UModels;

interface

uses
  System.Classes, System.SysUtils, FMX.Graphics;

type
  TEntity = class(TObject)
    private
      var
        FId: Integer;
        FImage: TBitmap;
    public
      constructor Create; overload;
      constructor Create(pId: Integer; pImage: TBitmap); overload;
      destructor Destroy; virtual;

      // properties
      property Id: Integer read FId write FId;
      property Image: TBitmap read FImage write FImage;
  end;

  TUser = class(TEntity)
    private
      var
        FNickname: string;
        FPassword: string;
        FEmail: string;
        FToken: string;
    public
      constructor Create; overload;
      constructor Create(pNickname: string; pPassword: string; pEmail: string); overload;

      // properties
      property Nickname: string read FNickname write FNickname;
      property Password: string read FPassword write FPassword;
      property Email: string read FEmail write FEmail;
      property Token: string read FToken write FToken;
  end;

  TArticle = class(TEntity)
    private
      var
        FTitle: string;
    public
      constructor Create;

      // properties
      property Title: string read FTitle write FTitle;
  end;

implementation

{ TEntity }

constructor TEntity.Create(pId: Integer; pImage: TBitmap);
begin
  FId := pId;
  FImage := TBitmap.Create;
  FImage.CopyFromBitmap(pImage);
end;

destructor TEntity.Destroy;
begin
  FImage.DisposeOf;
end;

constructor TEntity.Create;
begin
  FId := 0;
  FImage := TBitmap.Create;
end;

{ TUser }

constructor TUser.Create(pNickname, pPassword, pEmail: string);
begin
  inherited Create;
  FNickname := pNickname;
  FPassword := pPassword;
  FEmail := pEmail;
end;

constructor TUser.Create;
begin
  inherited Create;
  FNickname := '';
  FPassword := '';
  FEmail := '';
end;

{ TArticle }

constructor TArticle.Create;
begin
  inherited Create;
  FTitle := '';
end;

end.

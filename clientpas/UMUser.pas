unit UMUser;

interface

uses
  System.Classes, System.SysUtils, FMX.Dialogs,
  // Helpers
  USynchronizer;

type
  TMUser = class(TObject)
    private
      FId: Integer;
      FNickname: string;
      FLastName: string;
      FFirstName: string;
      FEmail: string;
      FPassword: string;
      FToken: string;
      FStreamImg: TBytesStream;

    public
      constructor Create(AGlobal: Boolean);
      destructor Destroy; virtual;

      procedure CopyImage(AStream: TBytesStream);

      property Id: Integer read FId write FId;
      property Nickname: string read FNickname write FNickname;
      property LastName: string read FLastName write FLastName;
      property FirstName: string read FFirstName write FFirstName;
      property Email: string read FEmail write FEmail;
      property Password: string read FPassword write FPassword;
      property Token: string read FToken write FToken;
      property StreamImg: TBytesStream read FStreamImg write CopyImage;
  end;

procedure ResetUserSession(ACurrentUser: TMUser);

var
  gMUser: TMUser;
  // Synchronizer shared memory SAFE.


implementation

{ TMUser }

constructor TMUser.Create(AGlobal: Boolean);
begin
  FId := 0;
  FNickname := '';
  FLastName := '';
  FFirstName := '';
  FEmail := '';
  FPassword := '';
  FStreamImg := nil;

  if AGlobal then
    TMREWS_gMUser := TMultiReadExclusiveWriteSynchronizer.Create;

  inherited Create;
end;

destructor TMUser.Destroy;
begin
  if Assigned(FStreamImg) then
    FStreamImg.Free;

  if Assigned(TMREWS_gMUser) then
    TMREWS_gMUser.Free;

  inherited;
end;

procedure ResetUserSession(ACurrentUser: TMUser);
begin
  ACurrentUser.Destroy;
  ACurrentUser := TMUser.Create(True);
end;

procedure TMUser.CopyImage(AStream: TBytesStream);
begin
  if not Assigned(FStreamImg) then
  begin
    FStreamImg := TBytesStream.Create;
    FStreamImg.CopyFrom(AStream, AStream.Size);
  end
  else
  begin
    FStreamImg.Clear;
    FStreamImg.CopyFrom(AStream, AStream.Size);
  end;
end;

end.

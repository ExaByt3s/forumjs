unit UCFrontend;

interface

uses
  System.Classes, System.SysUtils,
  // Helper,
  UHelper,
  USynchronizer,
  //Models
  UMUser;

type

  TCFrontend = class(TObject)
    public
      constructor Create;
      destructor Destroy; virtual;

      procedure GetSetting(out ANickname: string; out AStream: TBytesStream);
  end;

var
  CFrontend: TCFrontend;
  // Synchronizer shared memory SAFE.


implementation

{ TCFrontend }

constructor TCFrontend.Create;
begin
  TMREWS_CFrontend := TMultiReadExclusiveWriteSynchronizer.Create;
  inherited;
end;

destructor TCFrontend.Destroy;
begin
  if Assigned(TMREWS_CFrontend) then TMREWS_CFrontend.Free;
  inherited;
end;

procedure TCFrontend.GetSetting(out ANickname: string; out AStream: TBytesStream);
begin
  AStream := TBytesStream.Create;
  BeginRead(TMREWS_gMUser);
  ANickname := gMUser.Nickname;
  AStream.LoadFromStream(gMUser.StreamImg);
  EndRead(TMREWS_gMUser);
end;

end.

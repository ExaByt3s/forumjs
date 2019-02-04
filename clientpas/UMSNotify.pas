unit UMSNotify;

interface

uses
  System.Classes, System.SysUtils, System.JSON, UExceptHandler,
  // Helper
  UHelper,
  USynchronizer,
  // Models
  UMNotification,
  // Microservices
  UMSCommon;

type
  { closure comunication with controllers }
  CLOSURESendNotify = procedure(ANotify: TMNotification;
                        AExcept: TExceptHandler) of object;

  TMSNotify = class(TThread)
    private
      FCurrentId: Integer;
      FCurrentToken: string;
      FOffsetGlobal: Integer;
      { closure controllers }
      FSendNotify: CLOSURESendNotify;
    protected
      procedure Execute; override;
    public
      constructor Create;
      destructor Destroy; virtual;

      // methods
      function CheckConnection: Boolean;
      procedure GetGlobalNotification(out AExcept: TExceptHandler);

      property CurrentId: Integer read FCurrentId write FCurrentId;
      property CurrentToken: string read FCurrentToken write FCurrentToken;
      property OffsetGlobal: Integer read FOffsetGlobal write FOffsetGlobal;
      property SendNotify: CLOSURESendNotify read FSendNotify write FSendNotify;
  end;

procedure ResetMicroservice(AMicroservice: TMSNotify);

var
  MSNotify: TMSNotify;
  // Microservice Synchronizer Shared Memory SAFE.


implementation

{ TMSNotify }

constructor TMSNotify.Create;
begin
  FCurrentId := -1;
  FCurrentToken := '';
  FSendNotify := nil;
  // Synchronizer
  TMREWS_MSNotify := TMultiReadExclusiveWriteSynchronizer.Create;
  // Thread
  inherited Create(True);
  FreeOnTerminate := False;
end;

destructor TMSNotify.Destroy;
begin
  Terminate;
  TMREWS_MSNotify.Free;
  inherited;
end;

procedure TMSNotify.Execute;
var
  exp: TExceptHandler;
begin
  exp := nil;
  while not Terminated do
  begin
    // Notificaciones globales
    GetGlobalNotification(exp);

    TThread.Sleep(1000);
  end;
end;

function TMSNotify.CheckConnection: Boolean;
var
  body, res: TJSONObject;
  codError: Integer;
begin
  Result := False;

  body := TJSONObject.Create;
  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('getstatus', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);

  try
    Result := codError = 0;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure TMSNotify.GetGlobalNotification(out AExcept: TExceptHandler);
var
  body, res, curr: TJSONObject;
  arr: TJSONArray;
  codError, length: Integer;
  notify: TMNotification;
  I: Integer;
begin
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('id', IntToStr(CurrentId));
  body.AddPair('token', CurrentToken);
  body.AddPair('offset', IntToStr(OffsetGlobal));

  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('getgnotifications', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;
    length := StrToInt(res.GetValue('length').Value);
    if length = 0 then exit;

    arr := res.GetValue<TJSONArray>('data');
    for I := 0 to length - 1 do
    begin
      curr := TJSONObject(arr.Items[I]);
      notify := TMNotification.Create;

      notify.Id := StrToInt(curr.GetValue('nt_id').Value);
      notify.NotifyType := TNotifyType(StrToInt(curr.GetValue('type').Value));
      notify.InfoId := StrToInt(curr.GetValue('info_id').Value);

      BeginWrite(TMREWS_CBoard);
      SendNotify(notify, nil);
      BeginWrite(TMREWS_CBoard);

      FOffsetGlobal := notify.Id;

      notify.Free;
    end;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure ResetMicroservice(AMicroservice: TMSNotify);
begin
  if Assigned(AMicroservice) then
    AMicroservice.Destroy;

  AMicroservice := nil;
  AMicroservice := TMSNotify.Create;
end;

end.


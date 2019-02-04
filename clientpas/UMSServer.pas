unit UMSServer;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  REST.Client, REST.Types, IPPeerClient, UExceptHandler,
  // Helpers
  UHelper,
  USynchronizer,
  // Microservices
  UMSCommon,
  // Models
  UMUser,
  UMArticle;

type
  TMSServer = class(TObject)
    public
      constructor Create;
      destructor Destroy; virtual;

      procedure OnCreate;
      procedure OnClose;
      procedure ResetMicroservice;

      { Server methods }
      // Session
      procedure LogInUser(ANickname, APassword: string; out AExcept: TExceptHandler);
      procedure SignInUser(ANickname, ALastname, AFirstname, AEmail, APassword, AImg64: string;
                           out AExcept: TExceptHandler);
      // Articles
      procedure PushArticle(ARange: Integer; ATitle, ADesc, AImage: string;
                            out AExcept: TExceptHandler);
      procedure GetArticles(out AList: TList<Integer>; out AExcept: TExceptHandler);
      procedure GetArticle(AArticleId: Integer; out AArticle: TMArticle;
                            out AExcept: TExceptHandler);

      // Getters
      function GetUserPhoto(AId: Integer; out AStream: TBytesStream): Integer;
  end;

var
  MSServer: TMSServer;
  // Microservice Synchronizer Shared Memory SAFE.

implementation

constructor TMSServer.Create;
begin
  OnCreate;
  TMREWS_MSServer := TMultiReadExclusiveWriteSynchronizer.Create;
  inherited;
end;

destructor TMSServer.Destroy;
begin
  OnClose;

  if Assigned(TMREWS_MSServer) then
    TMREWS_MSServer.Free;
  inherited;
end;

procedure TMSServer.OnCreate;
begin
  gMUser := TMUser.Create(True);
end;

procedure TMSServer.OnClose;
begin
  if Assigned(gMUser) then
    gMUser.Destroy;
end;

procedure TMSServer.ResetMicroservice;
begin
  OnClose;
  OnCreate;
end;

procedure TMSServer.LogInUser(ANickname, APassword: string;
  out AExcept: TExceptHandler);
var
  body, res: TJSONObject;
  stream: TBytesStream;
  codError, imgce: Integer;
begin
  imgce := 0;
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('nickname', ANickname);
  body.AddPair('password', APassword);

  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('login', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;

    try
      gMUser.Id := StrToInt(res.GetValue('id').Value);
      gMUser.Nickname := ANickname;
      gMUser.Password := APassword;
      gMUser.Token := LowerCase(res.GetValue('token').Value);
      imgce := GetUserPhoto(gMUser.Id, stream);
      // Falta gestionar en tal caso que no posea imagen
      gMUser.StreamImg := stream;
    finally
      stream.Free;
    end;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure TMSServer.SignInUser(ANickname, ALastname, AFirstname, AEmail,
  APassword, AImg64: string; out AExcept: TExceptHandler);
var
  body, res: TJSONObject;
  codError: Integer;
begin
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('nickname', ANickname);
  body.AddPair('lastname', ALastname);
  body.AddPair('firstname', AFirstname);
  body.AddPair('email', AEmail);
  body.AddPair('password', APassword);
  body.AddPair('image', AImg64);

  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('signin', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;
  finally
    res.Free;
    body.Free;
  end;
end;

function TMSServer.GetUserPhoto(AId: Integer; out AStream: TBytesStream): Integer;
var
  body, res: TJSONObject;
  codError: Integer;
begin
  body := TJSONObject.Create;
  BeginRead(TMREWS_gMUser);
  body.AddPair('id', IntToStr(gMUser.Id));
  body.AddPair('token', gMUser.Token);
  EndRead(TMREWS_gMUser);
  body.AddPair('id_usr', IntToStr(AId));

  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('getuserphoto', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);
  Result := codError;

  try
    if codError <> 0 then exit;
    B64Decode(res.GetValue('image').Value, AStream);
  finally
    res.DisposeOf;
    body.DisposeOf;
  end;
end;

procedure TMSServer.PushArticle(ARange: Integer; ATitle, ADesc, AImage: string;
                                out AExcept: TExceptHandler);
var
  body, res: TJSONObject;
  codError: Integer;
begin
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;
  BeginRead(TMREWS_gMUser);
  body.AddPair('ac_id', IntToStr(gMUser.Id));
  EndRead(TMREWS_gMUser);
  body.AddPair('range', IntToStr(ARange));
  body.AddPair('title', ATitle);
  body.AddPair('description', ADesc);
  body.AddPair('image', AImage);

  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('pusharticle', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure TMSServer.GetArticles(out AList: TList<Integer>; out AExcept: TExceptHandler);
var
  body, res, curr: TJSONObject;
  arr: TJSONArray;
  codError, lengthData, I: Integer;
begin
  lengthData := 0;
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;
  BeginRead(TMREWS_gMUser);
  body.AddPair('id', IntToStr(gMUser.Id));
  body.AddPair('token', gMUser.Token);
  EndRead(TMREWS_gMUser);
  body.AddPair('offset', '0'); // No implementado

  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('getarticles', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;
    lengthData := StrToInt(res.GetValue('length').Value);
    if lengthData = 0 then exit;

    AList := TList<Integer>.Create;
    arr := TJSONArray(res.GetValue<TJSONArray>('data'));
    for I := 0 to lengthData - 1 do
    begin
      curr := TJSONObject(arr.Items[I]);
      AList.Add(StrToInt(curr.GetValue('ar_id').Value));
    end;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure TMSServer.GetArticle(AArticleId: Integer; out AArticle: TMArticle;
                            out AExcept: TExceptHandler);
var
  body, res, arr: TJSONObject;
  codError: Integer;
  stream: TBytesStream;
begin
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;

  BeginRead(TMREWS_gMUser);
  body.AddPair('id', IntToStr(gMUser.Id));
  body.AddPair('token', gMUser.Token);
  EndRead(TMREWS_gMUser);
  body.AddPair('ar_id', IntToStr(AArticleId));

  BeginRead(TMREWS_MSCommon);
  MSCommon.RRequest('getarticle', body, res);
  EndRead(TMREWS_MSCommon);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;

    arr := TJSONObject(res.GetValue<TJSONValue>('data'));

    AArticle := TMArticle.Create;
    AArticle.Id := AArticleId;
    AArticle.Owner := StrToInt(arr.GetValue('ac_id').Value);
    AArticle.Range := StrToInt(arr.GetValue('range').Value);
    AArticle.Title := arr.GetValue('title').Value;
    AArticle.Description := arr.GetValue('description').Value;
    B64Decode(arr.GetValue('image').Value, stream);
    AArticle.StreamImg := stream;
  finally
    stream.Free;
    res.Free;
    body.Free;
  end;
end;

end.

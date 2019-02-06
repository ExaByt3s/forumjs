unit UServerMethods;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  REST.Client, REST.Types, IPPeerClient,
  // Helper
  UExceptHandler,
  USynchronizer,
  UHelper,
  // Models
  UMArticle,
  UMUser;

{ Server Query }
procedure RRequest(AMethod: string; const ABody: TJSONObject; out ARes: TJSONObject);

{ All server methods have prefix <SM> }
procedure SMLogInUser(ANickname, APassword: string; out AExcept: TExceptHandler);
procedure SMSignInUser(ANickname, ALastname, AFirstname, AEmail, APassword, AImg64: string;
                           out AExcept: TExceptHandler);
procedure SMPushArticle(ARange: Integer; ATitle, ADesc, AImage: string;
                            out AExcept: TExceptHandler);
procedure SMGetArticles(out AList: TList<Integer>; out AExcept: TExceptHandler);
procedure SMGetArticle(AArticleId: Integer; out AArticle: TMArticle;
                            out AExcept: TExceptHandler);
function SMGetUserPhoto(AId: Integer; out AStream: TBytesStream): Integer;

const
  URL: string = 'http://localhost:3000/api/sm/';

implementation

procedure RRequest(AMethod: string; const ABody: TJSONObject; out ARes: TJSONObject);
var
  client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  ResultRes: TJSONObject;
  codError: Integer;
begin
  client := TRESTClient.Create('');
  request := TRESTRequest.Create(nil);
  response := TRESTResponse.Create(nil);
  client.BaseURL := URL;
  request.Client := client;
  request.Response := response;
  request.Method := rmPOST;
  request.Resource := AMethod;
  request.SynchronizedEvents := False;
  request.Timeout := 10000;
  request.Body.Add(ABody);

  try
    try
      request.Execute;
      if not response.JSONValue.TryGetValue('codError', codError) then
        raise Exception.Create('Invalid server response');

      ResultRes := TJSONObject(response.JSONValue.Clone);
    except
      on e: Exception do
      begin
        ResultRes := TJSONObject.Create;
        ResultRes.AddPair('codError', '-999');
      end;
    end;
  finally
    ARes := ResultRes; // Return Response;
    request.Free;
    response.Free;
    client.Free;
  end;
end;

procedure SMLogInUser(ANickname, APassword: string; out AExcept: TExceptHandler);
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
  RRequest('login', body, res);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;

    try
      gMUser.Id := StrToInt(res.GetValue('id').Value);
      gMUser.Nickname := ANickname;
      gMUser.Password := APassword;
      gMUser.Token := LowerCase(res.GetValue('token').Value);
      imgce := SMGetUserPhoto(gMUser.Id, stream);
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

procedure SMSignInUser(ANickname, ALastname, AFirstname, AEmail, APassword, AImg64: string;
                           out AExcept: TExceptHandler);
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
  RRequest('signin', body, res);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure SMPushArticle(ARange: Integer; ATitle, ADesc, AImage: string;
                            out AExcept: TExceptHandler);
var
  body, res: TJSONObject;
  codError: Integer;
begin
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('ac_id', IntToStr(gMUser.Id));
  body.AddPair('range', IntToStr(ARange));
  body.AddPair('title', ATitle);
  body.AddPair('description', ADesc);
  body.AddPair('image', AImage);
  RRequest('pusharticle', body, res);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure SMGetArticles(out AList: TList<Integer>; out AExcept: TExceptHandler);
var
  body, res, curr: TJSONObject;
  arr: TJSONArray;
  codError, length, I: Integer;
begin
  length := 0;
  AExcept := TExceptHandler.Create;
  body := TJSONObject.Create;
  body.AddPair('id', IntToStr(gMUser.Id));
  body.AddPair('token', gMUser.Token);
  body.AddPair('offset', '0'); // No implementado
  RRequest('getarticles', body, res);

  codError := StrToInt(res.GetValue('codError').Value);
  AExcept.CodError := codError;

  try
    if codError <> 0 then exit;
    length := StrToInt(res.GetValue('length').Value);
    if length = 0 then exit;

    AList := TList<Integer>.Create;
    arr := TJSONArray(res.GetValue<TJSONArray>('data'));
    for I := 0 to length - 1 do
    begin
      curr := TJSONObject(arr.Items[I]);
      AList.Add(StrToInt(curr.GetValue('ar_id').Value));
    end;
  finally
    res.Free;
    body.Free;
  end;
end;

procedure SMGetArticle(AArticleId: Integer; out AArticle: TMArticle;
                            out AExcept: TExceptHandler);
var
  body, res, arr: TJSONObject;
  codError: Integer;
  stream: TBytesStream;
begin
  AExcept := TExceptHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('id', IntToStr(gMUser.Id));
  body.AddPair('token', gMUser.Token);
  body.AddPair('ar_id', IntToStr(AArticleId));
  RRequest('getarticle', body, res);


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

function SMGetUserPhoto(AId: Integer; out AStream: TBytesStream): Integer;
var
  body, res: TJSONObject;
  codError: Integer;
begin
  body := TJSONObject.Create;
  body.AddPair('id', IntToStr(gMUser.Id));
  body.AddPair('token', gMUser.Token);
  body.AddPair('id_usr', IntToStr(AId));
  RRequest('getuserphoto', body, res);

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

end.

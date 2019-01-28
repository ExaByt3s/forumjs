unit UDMServer;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, REST.Types, IPPeerClient, UUtilities,
  FMX.Graphics, UHelper, UExceptionHandler,
  // Models
  UModels;

type
  TdmData = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    var
      FUser: TUser;

    function ExecRest(method: string; body: TJSONObject): TJSONObject;
  public
    // method - Session
    function LogIn(nickname, password: string): TExceptionHandler;
    function SignIn(nickname, firstname, lastname, email, password: string;
                    bm: TBitmap): TExceptionHandler;

    // getter
    function GetUserPhoto(id: Integer): TExceptionHandler;

    // property
    property User: TUser read FUser write FUser;
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TdmData }

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  FUser := TUser.Create;
end;

function TdmData.ExecRest(method: string; body: TJSONObject): TJSONObject;
var
  client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  codError: Integer;
  obj: TJSONObject;
begin
  Result := TJSONObject.Create;
  client := TRESTClient.Create(Self);
  request := TRESTRequest.Create(Self);
  response := TRESTResponse.Create(Self);
  client.BaseURL := 'http://localhost:3000/api/sm/';
  request.Client := client;
  request.Response := response;
  request.Method := rmPOST;
  request.Resource := method;
  request.SynchronizedEvents := False;
  request.Timeout := 10000;
  request.Body.Add(body);
  try
    request.Execute;
    if response.JSONValue.TryGetValue('codError', codError) = False then
      raise Exception.Create('Invalid server response');

    obj := response.JSONValue.Clone as TJSONObject;
    Result := obj;
  except
    on e: Exception do
    begin
      obj := TJSONObject.Create;
      obj.AddPair('codError', '-999');
      Result := obj;
    end;
  end;
end;

function TdmData.GetUserPhoto(id: Integer): TExceptionHandler;
var
  body: TJSONObject;
  res: TJSONObject;
  codError: Integer;
  byte: TBytes;
  b: TBytesStream;
begin
  Result := TExceptionHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('id', IntToStr(User.Id));
  body.AddPair('token', User.Token);
  body.AddPair('id_usr', IntToStr(id));
  res := ExecRest('getuserphoto', body);
  codError := StrToInt(res.GetValue('codError').Value);
  Result.CodError := codError;

  try
    if codError <> 0 then
      raise Exception.Create('GetUserPhoto');

    b := B64Decode(res.GetValue('image').Value);
    User.Image.LoadFromStream(b);

    Result.Response := True;
  except
    on e: Exception do
    begin
      Result.Response := False;
    end;
  end;

  b.DisposeOf;
  body.DisposeOf;
  res.DisposeOf;
end;

function TdmData.LogIn(nickname, password: string): TExceptionHandler;
var
  body: TJSONObject;
  res: TJSONObject;
  pass_hash: string;
  codError: Integer;
begin
  Result := TExceptionHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('nickname', nickname);
  pass_hash := MakeHash512(password);
  body.AddPair('password', pass_hash);
  res := ExecRest('login', body);
  codError := StrToInt(res.GetValue('codError').Value);
  Result.CodError := codError;
  try
    if codError <> 0 then
      raise Exception.Create('LogIn');

    User.Id := StrToInt(res.GetValue('id').Value);
    User.Nickname := nickname;
    User.Password := pass_hash;
    User.Token := res.GetValue('token').Value;

    GetUserPhoto(User.Id);

    Result.Response := True;
  except
    on e: Exception do
    begin
      Result.Response := False;
    end;
  end;

  body.DisposeOf;
  res.DisposeOf;
end;

function TdmData.SignIn(nickname, firstname, lastname, email,
  password: string; bm: TBitmap): TExceptionHandler;
var
  body: TJSONObject;
  res: TJSONObject;
  pass_hash: string;
  codError: Integer;
  b: TBytesStream;
  bytes: TBytes;
begin
  Result := TExceptionHandler.Create;

  body := TJSONObject.Create;
  body.AddPair('nickname', nickname);
  body.AddPair('lastname', lastname);
  body.AddPair('firstname', firstname);
  body.AddPair('email', email);
  pass_hash := MakeHash512(password);
  body.AddPair('password', pass_hash);
  b := TBytesStream.Create(bytes);
  bm.SaveToStream(b);
  body.AddPair('image', B64Encode(b));
  res := ExecRest('signin', body);
  codError := StrToInt(res.GetValue('codError').Value);
  Result.CodError := codError;

  try
    if codError <> 0 then
      raise Exception.Create('SignIn');

    Result.Response := True;
  except
    on e: Exception do
    begin
      Result.Response := False;
    end;
  end;

  b.DisposeOf;
  body.DisposeOf;
  res.DisposeOf;
end;

end.

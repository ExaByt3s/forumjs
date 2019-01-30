unit UDMServer;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, REST.Types, IPPeerClient, UUtilities,
  FMX.Graphics, UHelper, UExceptionHandler, System.SyncObjs,
  // Models
  UModels;

type
  TdmData = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    var
      FUser: TUser;

    procedure ExecRest(method: string; body: TJSONObject; out res: TJSONObject);
  public
    // method - Session
    procedure LogIn(nickname, password: string; var exce: TExceptionHandler);
    procedure SignIn(nickname, firstname, lastname, email, password: string;
                    bm: TBitmap; var exce: TExceptionHandler);

    destructor Destroy; virtual;

    // getter
    procedure GetUserPhoto(id: Integer; out stream: TBytesStream);

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

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  FUser.DisposeOf;
end;

destructor TdmData.Destroy;
begin
  //
end;

procedure TdmData.ExecRest(method: string; body: TJSONObject; out res: TJSONObject);
var
  client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  codError: Integer;
  obj: TJSONObject;
begin
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

    obj := TJSONObject(response.JSONValue.Clone);
  except
    on e: Exception do
    begin
      obj := TJSONObject.Create;
      obj.AddPair('codError', '-999');
    end;
  end;

  res := obj;

  Client.Free;
  Request.Free;
  Response.Free;
end;

procedure TdmData.GetUserPhoto(id: Integer; out stream: TBytesStream);
var
  body: TJSONObject;
  res: TJSONObject;
  codError: Integer;
begin
  body := TJSONObject.Create;
  body.AddPair('id', IntToStr(User.Id));
  body.AddPair('token', User.Token);
  body.AddPair('id_usr', IntToStr(id));
  ExecRest('getuserphoto', body, res);
  codError := StrToInt(res.GetValue('codError').Value);

  try
    if codError <> 0 then
      raise Exception.Create('GetUserPhoto');

    B64Decode(res.GetValue('image').Value, stream);
  finally
    body.Free;
    res.Free;
  end;
end;

procedure TdmData.LogIn(nickname, password: string; var exce: TExceptionHandler);
var
  body: TJSONObject;
  res: TJSONObject;
  pass_hash: string;
  codError: Integer;
begin
  body := TJSONObject.Create;
  body.AddPair('nickname', nickname);
  pass_hash := MakeHash512(password);
  body.AddPair('password', pass_hash);
  ExecRest('login', body, res);
  codError := StrToInt(res.GetValue('codError').Value);
  exce.CodError := codError;
  try
    if codError <> 0 then
      raise Exception.Create('LogIn');

    User.Id := StrToInt(res.GetValue('id').Value);
    User.Nickname := nickname;
    User.Password := pass_hash;
    User.Token := res.GetValue('token').Value;

    exce.Response := True;
  except
    on e: Exception do
    begin
      exce.Response := False;
    end;
  end;

  body.Free;
  res.Free;
end;

procedure TdmData.SignIn(nickname, firstname, lastname, email, password: string;
                    bm: TBitmap; var exce: TExceptionHandler);
var
  body: TJSONObject;
  res: TJSONObject;
  pass_hash: string;
  codError: Integer;
  b: TBytesStream;
  bytes: TBytes;
begin
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
  ExecRest('signin', body, res);
  codError := StrToInt(res.GetValue('codError').Value);
  exce.CodError := codError;

  try
    if codError <> 0 then
      raise Exception.Create('SignIn');

    exce.Response := True;
  except
    on e: Exception do
    begin
      exce.Response := False;
    end;
  end;

  b.Free;
  body.Free;
  res.Free;
end;

end.

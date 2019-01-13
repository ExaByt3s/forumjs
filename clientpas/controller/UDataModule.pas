unit UDataModule;

interface

uses
  System.SysUtils, System.Classes, System.JSON, REST.Types,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, REST.Json;

type
  TdmData = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    // vars
    _rclient: TRESTClient;
    _rrequest: TRESTRequest;
    _rresponse: TRESTResponse;

    // methods
    function ExecREST(method: ShortString; jsonAccess: TJSONObject): TJSONObject;
  public
    // interactuar with views
    function Login(nickname: ShortString; pass: ShortString): Boolean;
  end;

var
  dmData: TdmData;

const
  URL_BASE: ShortString = 'http://localhost:3000/api/sm/';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  //
end;

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  //
end;

function TdmData.ExecREST(method: ShortString; jsonAccess: TJSONObject): TJSONObject;
begin
  try
    _rclient := TRESTClient.Create(nil);
    _rrequest := TRESTRequest.Create(nil);
    _rresponse := TRESTResponse.Create(nil);
    _rclient.BaseURL := URL_BASE + method;
    _rrequest.Client := _rclient;
    _rrequest.Response := _rresponse;
    _rrequest.Method := rmPOST;
    _rrequest.Timeout := 5000;
    _rrequest.ClearBody;
    _rrequest.AddBody(jsonAccess);
    _rrequest.Execute;
    Result := _rresponse.JSONValue;
  finally
    _rclient.DisposeOf;
    _rrequest.DisposeOf;
    _rresponse.DisposeOf;
  end;

end;

function TdmData.Login(nickname, pass: ShortString): Boolean;
begin
  //
end;

end.

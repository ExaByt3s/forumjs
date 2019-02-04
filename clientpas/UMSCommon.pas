unit UMSCommon;

interface

uses
  System.Classes, System.SysUtils, System.JSON,
  REST.Client, REST.Types, IPPeerClient,
  // Helper
  UHelper,
  USynchronizer;

type
  TMSCommon = class(TObject)
    private
      FAppRunning: Boolean;
    public
      constructor Create;
      destructor Destroy; virtual;

      procedure RRequest(AMethod: string; const ABody: TJSONObject; out ARes: TJSONObject);

      property ApplicationRunning: Boolean read FAppRunning write FAppRunning;
  end;

const
  URL: string = 'http://localhost:3000/api/sm/';
var
  MSCommon: TMSCommon;
  // Microservice Synchronizer Shared Memory SAFE.


implementation

{ TMSCommon }

constructor TMSCommon.Create;
begin
  FAppRunning := True;
  TMREWS_MSCommon := TMultiReadExclusiveWriteSynchronizer.Create;
  inherited;
end;

destructor TMSCommon.Destroy;
begin
  FAppRunning := False;
  TMREWS_MSCommon.Free;
  inherited;
end;

procedure TMSCommon.RRequest(AMethod: string; const ABody: TJSONObject;
  out ARes: TJSONObject);
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

end.

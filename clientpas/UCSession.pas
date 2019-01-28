unit UCSession;

interface

uses
  System.Classes, FMX.Graphics, UExceptionHandler,
  UViewMgr,
  //microservice
  UDMServer;

type
  TCSession = class(TObject)
    private
      var
        FEh: TExceptionHandler;
    public
      constructor Create;
      destructor Destroy; virtual;

      // start session async
      function StartSession(const nickname, password: string): TExceptionHandler;
      function RegisterUser(const nickname, lastname, firstname, email, pass: string;
                            bmp: TBitmap): TExceptionHandler;

      // property
      property ExceptionH: TExceptionHandler read FEh write FEh;
  end;

var
  cSession: TCSession;

implementation

{ TCSession }

constructor TCSession.Create;
begin
  FEh := TExceptionHandler.Create;
end;

destructor TCSession.Destroy;
begin
  FEh.DisposeOf;
end;

function TCSession.RegisterUser(const nickname, lastname, firstname, email,
  pass: string; bmp: TBitmap): TExceptionHandler;
begin
  FEh := dmData.SignIn(nickname, lastname, firstname, email, pass, bmp);
  Result := FEh;
end;

function TCSession.StartSession(const nickname, password: string): TExceptionHandler;
begin
  FEh := dmData.LogIn(nickname, password);
  Result := FEh;
end;

end.

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
    public
      constructor Create;
      destructor Destroy; virtual;

      // start session async
      procedure StartSession(const nickname, password: string;
                              var exc: TExceptionHandler);
      procedure RegisterUser(const nickname, lastname, firstname, email, pass: string;
                            bmp: TBitmap; var exc: TExceptionHandler);
  end;

var
  cSession: TCSession;

implementation

{ TCSession }

constructor TCSession.Create;
begin
end;

destructor TCSession.Destroy;
begin
end;

procedure TCSession.RegisterUser(const nickname, lastname, firstname, email, pass: string;
                            bmp: TBitmap; var exc: TExceptionHandler);
begin
  dmData.SignIn(nickname, lastname, firstname, email, pass, bmp, exc);
end;

procedure TCSession.StartSession(const nickname, password: string;
                              var exc: TExceptionHandler);
begin
  dmData.LogIn(nickname, password, exc);
end;

end.

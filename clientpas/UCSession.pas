unit UCSession;

interface

uses
  System.Classes, System.SysUtils, System.Threading, UExceptHandler,
  // Manager
  UViewMgr,
  // Helper
  UHelper,
  USynchronizer,
  // ServerMethods
  UServerMethods,
  // Views
  UVFrontend;

type
  CLOSUREClearController = procedure(AInReturn: Boolean) of object;
  CLOSURETransitionTab = procedure(Sender: TObject) of object;

  TCSession = class(TObject)
    private
      { closure views }
      FClearController: CLOSUREClearController;
      FChangeTab: CLOSURETransitionTab;

    public
      constructor Create;
      destructor Destroy; virtual;

      procedure LogIn(ANickname, APassword: string);
      procedure SignIn(ANickname, ALastName, AFirstName, AEmail, APassword: string;
                       AStream: TBytesStream);

      property ClearController: CLOSUREClearController read FClearController write FClearController;
      property ChangeFrontTab: CLOSURETransitionTab read FChangeTab write FChangeTab;
  end;

const
  SLEEP_PER_PROCCESS = 2000; // Real value = 500

var
  CSession: TCSession;

implementation

{ TCSession }

constructor TCSession.Create;
begin
  FClearController := nil;
  FChangeTab := nil;
  inherited;
end;

destructor TCSession.Destroy;
begin
  inherited;
end;

procedure TCSession.LogIn(ANickname, APassword: string);
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
  procedure
  var
    exp: TExceptHandler;
    pass_hash: string;
  begin
    pass_hash := HASH512(APassword);
    SMLogInUser(LowerCase(ANickname), pass_hash, exp);

    TThread.Sleep(SLEEP_PER_PROCCESS); // Real sleep 500

    TThread.Synchronize(nil,
    procedure
    begin
      gViewMgr.Loading(False);
      if exp.CodError <> 0 then
      begin
        gViewMgr.PromptMessage(exp.Message);
        ClearController(True);
      end
      else
      begin
        gViewMgr.LaunchView(TViewType.vtStartSession);
      end;
    end);
    exp.Free;
  end);

  th.FreeOnTerminate := True;
  gViewMgr.Loading(True);
  th.Start;
end;

procedure TCSession.SignIn(ANickname, ALastName, AFirstName, AEmail, APassword: string;
                           AStream: TBytesStream);
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
  procedure
  var
    exp: TExceptHandler;
    pass_hash: string;
  begin
    pass_hash := HASH512(APassword);
    SMSignInUser(LowerCase(ANickname), LowerCase(ALastName),
                 LowerCase(AFirstName), LowerCase(AEmail), LowerCase(pass_hash),
                 B64Encode(AStream), exp);

    TThread.Sleep(SLEEP_PER_PROCCESS); // Real sleep 500

    TThread.Synchronize(nil,
    procedure
    begin
      gViewMgr.Loading(False);
      if exp.CodError <> 0 then
      begin
        gViewMgr.PromptMessage(exp.Message);
        ClearController(True);
      end
      else
      begin
        ChangeFrontTab(nil);
      end;
    end);

    AStream.Free;
    exp.Free;
  end);

  th.FreeOnTerminate := True;
  gViewMgr.Loading(True);
  th.Start;
end;

end.

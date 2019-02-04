unit UCBoard;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, FMX.StdCtrls,
  UExceptHandler,
  // Helper
  UHelper,
  USynchronizer,
  //Model
  UMArticle,
  UMNotification,
  // Microservice
  UMSServer,
  UMSNotify,
  // manager
  UViewMgr;

type
  { for view }
  CLOSUREPushArticle = procedure(const AArticle: TMArticle) of object;
  CLOSUREDispatchMsg = procedure(AActive: Boolean; const AMessage: string = '') of object;
  CLOSUREChangeTab = procedure(ASender: TObject) of object;

  TCBoard = class(TObject)
    private
      FTagCount: Integer;

      { vars backup }
      FLabelBackup: TLabel;  // for DispatchMessage

      { closure with microservice }

      { closure with view }
      FPushArticle: CLOSUREPushArticle;
      FDispatchMsg: CLOSUREDispatchMsg;
      FChangeTab: CLOSUREChangeTab;
    public
      constructor Create;
      destructor Destroy; virtual;

      { Obtener articulos e insertarlos al VSB }
      procedure GetArticles;
      // this method every call on a thread.
      procedure GetArticle(AArticleId: Integer; AArticle: TMArticle;
                           AExcept: TExceptHandler);
      { Proceso para agregar articulos al servidor }
      procedure AddArticle(ATitle, ADesc: string; AStream: TBytesStream);

      { Obtener el valor y la memoria del puntero para almacenar }
      procedure CopyObject(AObject: TLabel);
      procedure ReleaseBackup(var AObject: TLabel);

      { Notifications }
      procedure ReceivedNotification(ANotify: TMNotification;
                                     AExcept: TExceptHandler);

      property TagCount: Integer read FTagCount write FTagCount;
      property LabelBackup: TLabel read FLabelBackup write CopyObject;
      property PushArticle: CLOSUREPushArticle read FPushArticle write FPushArticle;
      property DispatchMessage: CLOSUREDispatchMsg read FDispatchMsg write FDispatchMsg;
      property ChangeTab: CLOSUREChangeTab read FChangeTab write FChangeTab;
  end;

var
  CBoard: TCBoard;
  // Synchronizer shared memory SAFE.

implementation

{ TCBoard }

constructor TCBoard.Create;
begin
  FTagCount := 10;
  FPushArticle := nil;
  FDispatchMsg := nil;
  FChangeTab := nil;

  TMREWS_CBoard := TMultiReadExclusiveWriteSynchronizer.Create;
  inherited;
end;

destructor TCBoard.Destroy;
begin
  if Assigned(LabelBackup) then FLabelBackup.Free;
  if Assigned(TMREWS_CBoard) then TMREWS_CBoard.Free;
  inherited;
end;

procedure TCBoard.GetArticles;
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
  procedure
  var
    list: TList<Integer>;
    article: TMArticle;
    I: Integer;
    exp: TExceptHandler;
    cut_process: Boolean;
  begin
    try
      article := nil;
      exp := nil;

      BeginRead(TMREWS_MSServer);
      MSServer.GetArticles(list, exp);
      EndRead(TMREWS_MSServer);
      cut_process := exp.CodError <> 0;

      TThread.Sleep(500);

      if not cut_process then
      begin
        exp.Free;
        for I := list.Count - 1 downto 0 do
        begin
          GetArticle(list.Items[I], article, exp);
        end;
        exit; // goto finally
      end;

      TThread.Synchronize(nil,
      procedure
      begin
        if cut_process then
        begin
          DispatchMessage(True, exp.Message);
        end;
      end);
    finally
      if Assigned(list) then list.Free;
      if Assigned(exp) then exp.Free;
    end;
  end);

  th.FreeOnTerminate := True;
  th.Start;
end;

procedure TCBoard.GetArticle(AArticleId: Integer; AArticle: TMArticle;
                            AExcept: TExceptHandler);
begin
  try
    BeginRead(TMREWS_MSServer);
    MSServer.GetArticle(AArticleId, AArticle, AExcept);
    EndRead(TMREWS_MSServer);
    TThread.Sleep(500);
    TThread.Synchronize(nil,
    procedure
    begin         // Manegar posibles errores [FALTA]
      PushArticle(AArticle);
    end);
  finally
    AArticle.Destroy;
    AArticle := nil;
    FreeAndNil(AExcept);
  end;
end;

procedure TCBoard.CopyObject(AObject: TLabel);
begin
  if Assigned(LabelBackup) then
    FLabelBackup.Free;

  FLabelBackup := TLabel(AObject.Clone(AObject));
end;

procedure TCBoard.ReleaseBackup(var AObject: TLabel);
begin
  AObject.Text := FLabelBackup.Text;
  FreeAndNil(FLabelBackup);
end;

procedure TCBoard.AddArticle(ATitle, ADesc: string; AStream: TBytesStream);
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
  procedure
  var
    exp: TExceptHandler;
  begin
    try
      BeginRead(TMREWS_MSServer);
      MSServer.PushArticle(0, ATitle, ADesc, B64Encode(AStream), exp);
      EndRead(TMREWS_MSServer);

      TThread.Sleep(1000);

      TThread.Synchronize(nil,
      procedure
      var
        btn: TButton;
      begin
        gViewMgr.Loading(False);
        if exp.CodError <> 0 then
          gViewMgr.PromptMessage(exp.Message)
        else
        begin
          btn := TButton.Create(nil);
          btn.Tag := 0; // Board
          ChangeTab(TObject(btn));
          btn.Free;
        end;
      end);
    finally
      AStream.Free;
      exp.Free;
    end;
  end);

  th.FreeOnTerminate := True;
  gViewMgr.Loading(True);
  th.Start;
end;

procedure TCBoard.ReceivedNotification(ANotify: TMNotification;
                                        AExcept: TExceptHandler);
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(
  procedure
  var
    exp: TExceptHandler;
    article: TMArticle;
  begin
    try
      if Assigned(AExcept) then FreeAndNil(AExcept);
      article := nil;
      // Falta manejar la posible excepcion que viene del Microservice.
      case ANotify.NotifyType of
      ntNewArticle:
        begin
          GetArticle(ANotify.InfoId, article, exp);
        end;
      end;
    finally
      if Assigned(exp) then exp.Free;
    end;
  end);
  th.FreeOnTerminate := True;
  th.Start;
end;

end.

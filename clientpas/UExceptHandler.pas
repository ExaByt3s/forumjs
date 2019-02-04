unit UExceptHandler;

interface

uses
  System.Classes;

type
  TECodError = (
    ceSueccessfully     = 0,
    ceErroToken         = -1,
    ceUserNotFound      = -2,
    ceDataError         = -3,
    ceJSONInvalid       = -4,
    ceDBEmpty           = -5,
    ceIncorrectData     = -6,
    ceUserEmailExists   = -7,
    ceArticleNotFound   = -8,
    ceArticleNotHaveLike = -9,
    ceArticlesEmpty     = -10,
    ceUserNotHaveImage  = -11,
    ceOnlyForDeveloper  = -12,
    ceErrorQuery        = -99,
    ceConnectionError   = -999
  );

  TExceptHandler = class(TObject)
    private
      FCodError: Integer;

      function TranslateMessage: string;
    public
      constructor Create;
      destructor Destroy; virtual;

      property CodError: Integer read FCodError write FCodError;
      property Message: string read TranslateMessage;
  end;

implementation

{ TExceptHandler }

constructor TExceptHandler.Create;
begin
  FCodError := 0;
  inherited;
end;

destructor TExceptHandler.Destroy;
begin
  inherited;
end;

function TExceptHandler.TranslateMessage: string;
var
  msg: string;
begin
  Result := '';

  case TECodError(FCodError) of
  ceSueccessfully:      msg := 'Sucessfully!';
  ceErroToken:          msg := '';
  ceUserNotFound:       msg := '';
  ceDataError:          msg := '';
  ceJSONInvalid:        msg := '';
  ceDBEmpty:            msg := '';
  ceIncorrectData:      msg := 'Incorrect Data!';
  ceUserEmailExists:    msg := 'User or Email exists!';
  ceArticleNotFound:    msg := '';
  ceArticleNotHaveLike: msg := '';
  ceArticlesEmpty:      msg := 'Not have articles!';
  ceUserNotHaveImage:   msg := '';
  ceOnlyForDeveloper:   msg := '';
  ceErrorQuery:         msg := '';
  ceConnectionError:    msg := 'Failed to server connection!';
  end;

  Result := msg;
end;

end.

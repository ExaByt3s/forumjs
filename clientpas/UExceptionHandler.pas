unit UExceptionHandler;

interface

uses
  System.Classes;

type
  TExceptionHandler = class(TObject)
    private
      var
        FResponse: Boolean;
        FCodError: Integer;
        FMethod: string;
    public
      constructor Create; overload;
      constructor Create(res: Boolean); overload;
      constructor Create(res: Boolean; cerror: Integer; method: string); overload;

      function ProcessCodError: string;

      property Response: Boolean read FResponse write FResponse;
      property CodError: Integer read FCodError write FCodError;
      property Method: string read ProcessCodError write FMethod;
  end;

implementation

{ TExceptionHandler }

constructor TExceptionHandler.Create;
begin
  FResponse := True;
  FCodError := 0;
  FMethod := '';
end;

constructor TExceptionHandler.Create(res: Boolean);
begin
  FResponse := res;
  FCodError := 0;
  FMethod := '';
end;

constructor TExceptionHandler.Create(res: Boolean; cerror: Integer;
  method: string);
begin
  FResponse := res;
  FCodError := cerror;
  FMethod := method;
end;

function TExceptionHandler.ProcessCodError: string;
begin
  case CodError of
    -1: Result := 'Error token!';
    -2: Result := 'User not found!';
    -3: Result := 'Data incompleta!';
    -4: Result := 'JSON invalid!';
    -5: Result := 'DB empty';
    -6: Result := 'Datos incorrectos!';
    -7: Result := 'User or Email Exists!';
    -98: Result := 'Only for Developers!';
    -99: Result := 'Error query!';
    -999: Result := 'Connection error!';
  else Method := 'Knownt';
  end;
  Method := Result;
end;

end.

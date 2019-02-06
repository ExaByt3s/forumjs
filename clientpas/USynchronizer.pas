unit USynchronizer;

interface

uses
  System.Classes, System.SysUtils;

// Facilitar la forma en que se sync una variable global altamente concurrida.
procedure BeginRead(var ALock: TMultiReadExclusiveWriteSynchronizer);
procedure EndRead(var ALock: TMultiReadExclusiveWriteSynchronizer);
procedure BeginWrite(var ALock: TMultiReadExclusiveWriteSynchronizer);
procedure EndWrite(var ALock: TMultiReadExclusiveWriteSynchronizer);

var
  { Microservices }
  { Controllers }
  TMREWS_CBoard: TMultiReadExclusiveWriteSynchronizer;
  TMREWS_CFrontend: TMultiReadExclusiveWriteSynchronizer;
  { Models }
  TMREWS_gMUser: TMultiReadExclusiveWriteSynchronizer;

implementation

procedure BeginRead(var ALock: TMultiReadExclusiveWriteSynchronizer);
begin
  ALock.BeginRead;
end;

procedure EndRead(var ALock: TMultiReadExclusiveWriteSynchronizer);
begin
  ALock.EndRead;
end;

procedure BeginWrite(var ALock: TMultiReadExclusiveWriteSynchronizer);
begin
  ALock.BeginWrite;
end;

procedure EndWrite(var ALock: TMultiReadExclusiveWriteSynchronizer);
begin
  ALock.EndRead;
end;

end.

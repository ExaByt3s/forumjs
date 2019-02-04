unit USynchronizer;

interface

uses
  System.Classes, System.SysUtils;

var
  { Microservices }
  TMREWS_MSCommon: TMultiReadExclusiveWriteSynchronizer;
  TMREWS_MSServer: TMultiReadExclusiveWriteSynchronizer;
  TMREWS_MSNotify: TMultiReadExclusiveWriteSynchronizer;
  { Controllers }
  TMREWS_CBoard: TMultiReadExclusiveWriteSynchronizer;
  TMREWS_CFrontend: TMultiReadExclusiveWriteSynchronizer;
  { Models }
  TMREWS_gMUser: TMultiReadExclusiveWriteSynchronizer;

implementation

end.

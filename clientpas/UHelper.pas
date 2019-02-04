unit UHelper;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Hash, IdCoderMIME;

type
  TPair<TFirst, TSecond> = record
    First: TFirst;
    Second: TSecond;
  end;

// Base64 Enc/Dec
function B64Encode(AStream: TBytesStream): string;
procedure B64Decode(const ASource: string; out AStream: TBytesStream);

// Hash512
function HASH512(const AText: string): string;

// Facilitar la forma en que se sync una variable global altamente concurrida.
procedure BeginRead(var ALock: TMultiReadExclusiveWriteSynchronizer);
procedure EndRead(var ALock: TMultiReadExclusiveWriteSynchronizer);
procedure BeginWrite(var ALock: TMultiReadExclusiveWriteSynchronizer);
procedure EndWrite(var ALock: TMultiReadExclusiveWriteSynchronizer);

implementation

function B64Encode(AStream: TBytesStream): string;
begin
  AStream.Position := 0;
  Result := TidEncoderMIME.EncodeStream(AStream);
end;

procedure B64Decode(const ASource: string; out AStream: TBytesStream);
begin
  AStream := TBytesStream.Create;
  TIdDecoderMIME.DecodeStream(ASource, AStream);
  AStream.Position := 0;
end;

function HASH512(const AText: string): string;
var
  hash: string;
begin
  hash := THashSHA2.GetHashString(LowerCase(AText),
    THashSHA2.TSHA2Version.SHA512);
  Result := LowerCase(hash);
end;

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

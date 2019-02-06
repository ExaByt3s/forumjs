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

end.

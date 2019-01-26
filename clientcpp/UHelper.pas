unit UHelper;

interface

uses
  System.JSON, Classes, StrUtils, SysUtils, IdCoderMIME;

const
  Code64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

type
  THelpJArray = class
    class function GetJArrayRow(org: TJSONValue; val: String): TJSONObject; static;
  end;

  TEncryp = class
    class function B64Encode(bs: TBytesStream): String; static;
    class function B64Decode(src: String): TBytesStream; static;
  end;

implementation

{ THelpJArray }

class function THelpJArray.GetJArrayRow(org: TJSONValue; val: String): TJSONObject;
begin
  Result := org.GetValue<TJSONObject>(val);
end;

{ TEncryp }

class function TEncryp.B64Decode(src: String): TBytesStream;
var
  LRes: TBytesStream;
begin
  LRes := TBytesStream.Create();
  TIdDecoderMIME.DecodeStream(src, LRes);
  LRes.Position := 0;
  Result := LRes;
end;

class function TEncryp.B64Encode(bs: TBytesStream): String;
begin
  bs.Position := 0;
  Result := TIdEncoderMIME.EncodeStream(bs);
end;

end.

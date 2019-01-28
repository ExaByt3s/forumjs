unit UHelper;

interface

uses
  System.JSON, System.Classes, System.StrUtils, IdCoderMIME;

function GetJArrayRow(org: TJSONValue; val: string): TJSONObject;
function B64Encode(bs: TBytesStream): string;
function B64Decode(src: string): TBytesStream;

implementation

  function GetJArrayRow(org: TJSONValue; val: string): TJSONObject;
  begin
    Result := org.GetValue<TJSONObject>(val);
  end;

  function B64Encode(bs: TBytesStream): string;
  begin
    bs.Position := 0;
    Result := TIdEncoderMIME.EncodeStream(bs);
  end;

  function B64Decode(src: string): TBytesStream;
  var
    LRes: TBytesStream;
  begin
    LRes := TBytesStream.Create();
    TIdDecoderMIME.DecodeStream(src, LRes);
    LRes.Position := 0;
    Result := LRes;
  end;
end.

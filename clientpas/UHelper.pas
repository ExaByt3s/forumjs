unit UHelper;

interface

uses
  System.JSON, System.Classes, System.StrUtils, IdCoderMIME;

procedure GetJArrayRow(org: TJSONValue; val: string; out res: TJSONObject);
function B64Encode(bs: TBytesStream): string;
procedure B64Decode(src: string; var stream: TBytesStream);

implementation

  procedure GetJArrayRow(org: TJSONValue; val: string; out res: TJSONObject);
  begin
    res := org.GetValue<TJSONObject>(val);
  end;

  function B64Encode(bs: TBytesStream): string;
  begin
    bs.Position := 0;
    Result := TIdEncoderMIME.EncodeStream(bs);
  end;

  procedure B64Decode(src: string; var stream: TBytesStream);
  begin
    TIdDecoderMIME.DecodeStream(src, stream);
    stream.Position := 0;
  end;
end.

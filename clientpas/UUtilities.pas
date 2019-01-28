unit UUtilities;

interface

uses
  System.Classes, System.SysUtils, System.Hash;

function MakeHash512(const text: string): string;

implementation

  function MakeHash512(const text: string): string;
  var
    hash: string;
  begin
    hash := THashSHA2.GetHashString(LowerCase(text), ThashSHA2.TSHA2Version.SHA512);
    Result := LowerCase(hash);
  end;

end.

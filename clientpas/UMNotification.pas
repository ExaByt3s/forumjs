unit UMNotification;

interface

uses
  System.Classes, System.SysUtils;

type
  TNotifyType = (ntNone=-1, ntNewArticle=0);

  TMNotification = class(TObject)
    private
      FId: Integer;
      FNotifyType: TNotifyType;
      FInfoId: Integer;
    public
      constructor Create;
      destructor Destroy; virtual;

      property Id: Integer read FId write FId;
      property NotifyType: TNotifyType read FNotifyType write FNotifyType;
      property InfoId: Integer read FInfoId write FInfoId;
  end;

implementation

{ TMNotification }

constructor TMNotification.Create;
begin
  FId := -1;
  FNotifyType := ntNone;
  FInfoId := -1;
  inherited;
end;

destructor TMNotification.Destroy;
begin
  inherited;
end;

end.

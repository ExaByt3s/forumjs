unit UViewMgr;

interface

uses
  System.Classes, FMX.Layouts, FMX.Forms;

type
  // Type view
  TViewType = (vtStartSession=0, vtLogout=1);

  // Closure
  CLOSUREPrompt = procedure(const AMessage: string) of object;
  CLOSURELoading = procedure(AActive: Boolean) of object;
  CLOSURELaunchView = procedure(AViewType: TViewType) of object;

  TViewMgr = class(TObject)
    private
      FLaunchV: CLOSURELaunchView;
      FPrompt: CLOSUREPrompt;
      FLoading: CLOSURELoading;
    public
      constructor Create;
      destructor Destroy; virtual;

      class procedure GetView(AForm: TComponentClass; AParent: TLayout;
                   ANewRef: TForm; ALastRef: TForm; const AComponent: string); static;

      // closure
      property LaunchView: CLOSURELaunchView read FLaunchV write FLaunchV;
      property PromptMessage: CLOSUREPrompt read FPrompt write FPrompt;
      property Loading: CLOSURELoading read FLoading write FLoading;
  end;

var
  gViewMgr: TViewMgr;

implementation

{ TViewMgr }

constructor TViewMgr.Create;
begin
  PromptMessage := nil;
  inherited;
end;

destructor TViewMgr.Destroy;
begin
  LaunchView := nil;
  PromptMessage := nil;
  Loading := nil;

  inherited;
end;

class procedure TViewMgr.GetView(AForm: TComponentClass; AParent: TLayout;
                   ANewRef: TForm; ALastRef: TForm; const AComponent: string);
var
  I: Integer;
begin
  for I := AParent.ControlsCount - 1 downto 0 do
      AParent.RemoveObject(AParent.Controls[i]);

  if Assigned(ALastRef) then
  begin
    ALastRef.DisposeOf;
    ALastRef := nil;
  end;

  if Assigned(ANewRef) then
  begin
    ANewRef.Destroy;
    ANewRef := nil;
  end;

  Application.CreateForm(AForm, ANewRef);
  AParent.AddObject(TLayout(ANewRef.FindComponent(AComponent)));
end;

end.

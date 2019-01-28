unit UViewMgr;

interface

uses
  System.Classes, FMX.Layouts, FMX.Forms;

type
  // Type view
  TViewType = (START_SESSION=0, LOGOUT_SESSION=1);

  // Closure
  CLOSUREPrompt = procedure(const msg: string) of object;
  CLOSURELaunchView = procedure(viewtype: TViewType) of object;

  TViewMgr = class(TObject)
    private
      var
        CB_FPrompt: CLOSUREPrompt;
        CB_FLaunchView: CLOSURELaunchView;
    public
      constructor Create;

      // closure
      property PromptMsg: CLOSUREPrompt read CB_FPrompt write CB_FPrompt;
      property LaunchView: CLOSURELaunchView read CB_FLaunchView write CB_FLaunchView;
  end;

procedure GetViews(pForm: TComponentClass; parent: TLayout; ref: TForm; const comp_name: string);

var
  viewMgr: TViewMgr;

implementation

{ TViewMgr }

constructor TViewMgr.Create;
begin
  CB_FPrompt := nil;
end;

procedure GetViews(pForm: TComponentClass; parent: TLayout; ref: TForm; const comp_name: string);
var
  i: Integer;
begin
  if (ref = nil) or (Assigned(ref)) and
      (ref.ClassName <> pForm.ClassName) then
  begin
    for i := parent.ControlsCount - 1 downto 0 do
      parent.RemoveObject(parent.Controls[i]);

    ref.DisposeOf;
    ref := nil;
    Application.CreateForm(pForm, ref);
    parent.AddObject(TLayout(ref.FindComponent(comp_name)));
  end;
end;

end.

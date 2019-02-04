unit UVBoards;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo,
  // Helper
  UHelper,
  USynchronizer,
  // Models
  UMArticle,
  // Controller
  UCBoard,
  // manager
  UViewMgr;

type
  TfrmVBoards = class(TForm)
    lyBViews: TLayout;
    tbViews: TTabControl;
    tbiDahsboard: TTabItem;
    tbiTemplates1: TTabItem;
    rctPanelArticle: TRectangle;
    imgArticle: TImage;
    lblTitleArticle: TLabel;
    lblDescArticle: TLabel;
    vsbBoard: TVertScrollBox;
    lyArticleTemplate: TLayout;
    rctPanelNVSB: TRectangle;
    lyNotifyVSB: TLayout;
    lblpanelmessage: TLabel;
    tbiAddArticle: TTabItem;
    lyPanelAA: TLayout;
    rctBack: TRectangle;
    imgArticleA: TImage;
    lblTitleA: TLabel;
    lblDescA: TLabel;
    lyDispatchEdit: TLayout;
    rctBackgroundDE: TRectangle;
    rctPanelAArticle: TRectangle;
    mmTextAA: TMemo;
    btnCancelOp: TButton;
    Layout1: TLayout;
    btnConfirmOp: TButton;
    Layout2: TLayout;
    btnGotoBoard: TButton;
    btnAddArticle: TButton;
    btnGotoAArticle: TButton;
    lyLoading: TLayout;
    rctBackgroundL: TRectangle;
    AniIndicator1: TAniIndicator;
    odloadphoto: TOpenDialog;
    btnLoadPhoto: TButton;
    lyIntraNotify: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddArticleClick(Sender: TObject);
    procedure imgArticleAMouseEnter(Sender: TObject);
    procedure imgArticleAMouseLeave(Sender: TObject);
    procedure btnLoadPhotoEnter(Sender: TObject);
  private
    { Private declarations }
  public

    { Helper for Push Article into VertScrollBox }
    procedure GetScrollContent(out ASContent: TScrollContent);
    procedure ClearVSB;
    function GetOffsetItem: Single;

    { AddArticle region }

    { AddArticle endregion }

    { Apply common events }
    procedure FocusUnFocusLabel(Sender: TObject);
    procedure CallDispatchEdit(Sender: TObject);
    procedure DispatchEditExecute(Sender: TObject);
    procedure DispatchEditSave(Sender: TObject);
    procedure GotoTabsButton(Sender: TObject);

    { closure }
    procedure PushArticleIntoVSB(const AArticle: TMArticle);
    procedure ShowDispatchMessage(AActive: Boolean; const AMessage: string = '');
    procedure Loading(AActive: Boolean);
  end;

var
  frmVBoards: TfrmVBoards;

implementation

{$R *.fmx}

{ TfrmVBoards }

procedure TfrmVBoards.FormCreate(Sender: TObject);
begin
  { set common events }
  lblTitleA.OnMouseEnter := FocusUnFocusLabel;
  lblTitleA.OnMouseLeave := FocusUnFocusLabel;
  lblTitleA.OnClick := CallDispatchEdit;
  lblDescA.OnMouseEnter := FocusUnFocusLabel;
  lblDescA.OnMouseLeave := FocusUnFocusLabel;
  lblDescA.OnClick := CallDispatchEdit;
  btnConfirmOp.OnClick := DispatchEditSave;
  btnCancelOp.OnClick := DispatchEditSave;
  btnGotoBoard.OnClick := GotoTabsButton;
  btnGotoAArticle.OnClick := GotoTabsButton;
  btnLoadPhoto.OnMouseEnter := imgArticleAMouseEnter;
  btnLoadPhoto.OnMouseLeave := imgArticleAMouseLeave;

  { settings }
  BeginRead(TMREWS_CBoard);
  CBoard.PushArticle := PushArticleIntoVSB;
  CBoard.DispatchMessage := ShowDispatchMessage;
  CBoard.ChangeTab := GotoTabsButton;
  EndRead(TMREWS_CBoard);
  gViewMgr.Loading := Loading;

  { Initializer }
  BeginRead(TMREWS_CBoard);
  CBoard.GetArticles;
  EndRead(TMREWS_CBoard);
end;

procedure TfrmVBoards.FormDestroy(Sender: TObject);
begin
  { Clear closure }
  CBoard.PushArticle := nil;
  CBoard.DispatchMessage := nil;
  gViewMgr.Loading := nil;
end;

procedure TfrmVBoards.PushArticleIntoVSB(const AArticle: TMArticle);
var
  template: TLayout;
  offset: Single;
  I, II: Integer;
  // templatechild
  bmp: TImage;
  td_label: TLabel;
begin
  offset := 0.0;
  template := TLayout(lyArticleTemplate.Clone(lyArticleTemplate));
  template.Tag := CBoard.TagCount;

  if CBoard.TagCount > 10 then
    offset := GetOffsetItem;

  offset := offset + 10.0; // N distance entre articles.
  template.Position.Y := offset;
  CBoard.TagCount := CBoard.TagCount + 1;

  for I := template.ChildrenCount - 1 downto 0 do
  begin
    if template.Children[I].Tag = 99 then // Rectangle Panel
    begin
      for II := template.Children[I].ChildrenCount - 1 downto 0 do
      begin
        if template.Children[I].Children[II].Tag = 100 then // image
        begin
          bmp := TImage(template.Children[I].Children[II]);
          bmp.Bitmap.LoadFromStream(AArticle.StreamImg);
        end
        else if template.Children[I].Children[II].Tag = 101 then // title
        begin
          td_label := TLabel(template.Children[I].Children[II]);
          td_label.Text := AArticle.Title;
        end
        else if template.Children[I].Children[II].Tag = 102 then // desc
        begin
          td_label := TLabel(template.Children[I].Children[II]);
          td_label.Text := AArticle.Description;
        end;
      end;
    end;
  end;

  vsbBoard.AddObject(TFmxObject(template));
  vsbBoard.UpdateEffects;
end;

procedure TfrmVBoards.ShowDispatchMessage(AActive: Boolean; const AMessage: string = '');
begin
  lblpanelmessage.Text := AMessage;
  lyIntraNotify.Visible := AActive;
end;

{ ESTA RUTINA SE PUEDEM MEJORAR. }
procedure TfrmVBoards.ClearVSB;
var
  I, II, lycount: Integer;
  lyouts: array of TLayout;
  RSContent: TScrollContent;
begin
  lycount := 0;
  GetScrollContent(RSContent);

  // Count Articles(TLayout) have SCrollContent.
  for I := RSContent.ControlsCount - 1 downto 0 do
  begin
    // Falta mejorar esta rutina.
    if RSContent.Controls[I].Tag >= 10 then Inc(lycount);
  end;

  SetLength(lyouts, lycount);
  II := 0;

  for I := RSContent.ControlsCount - 1 downto 0 do
  begin
    if RSContent.Controls[I].Tag >= 10 then
    begin
      lyouts[II] := TLayout(RSContent.Controls[I]);
      II := II + 1;
    end;
  end;

  for I := II - 1 downto 0 do
  begin
    lyouts[I].Parent := nil;
    lyouts[I].Free;
  end;

  vsbBoard.UpdateEffects;
end;

function TfrmVBoards.GetOffsetItem: Single;
var
  I: Integer;
  layout: TLayout;
  RSContent: TScrollContent;
begin
  Result := 0.0;
  GetScrollContent(RSContent);
  for I := RSContent.ControlsCount - 1 downto 0 do
  begin
    if RSContent.Controls[I].Tag = CBoard.TagCount - 1 then
    begin
      layout := TLayout(RSContent.Controls[I]);
      Result := layout.Position.Y + layout.Height; // bottom
      break;
    end;
  end;
end;

procedure TfrmVBoards.GetScrollContent(out ASContent: TScrollContent);
var
  I: Integer;
begin
  ASContent := nil;
  for I := vsbBoard.ControlsCount - 1 downto 0 do
  begin
    if vsbBoard.Controls[I].ClassName = TScrollContent.ClassName then
    begin
      ASContent := TScrollContent(vsbBoard.Controls[I]);
      break;
    end;
  end;
end;

procedure TfrmVBoards.FocusUnFocusLabel(Sender: TObject);
var
  lbl: TLabel;
begin
  lbl := TLabel(Sender);
  if not (TFontStyle.fsBold in lbl.Font.Style) then
    lbl.Font.Style := lbl.Font.Style + [TFontStyle.fsBold]
  else
    lbl.Font.Style := lbl.Font.Style - [TFontStyle.fsBold];

  lbl.Repaint;
end;

procedure TfrmVBoards.btnAddArticleClick(Sender: TObject);
var
  stream: TBytesStream;
begin
  stream := TBytesStream.Create;
  imgArticleA.Bitmap.SaveToStream(stream);
  BeginRead(TMREWS_CBoard);
  CBoard.AddArticle(lblTitleA.Text, lblDescA.Text, stream);
  EndRead(TMREWS_CBoard);
end;

procedure TfrmVBoards.GotoTabsButton(Sender: TObject);
var
  btn: TButton;
  tab: Integer;
begin
  tab := 0;
  btn := TButton(Sender);
  if btn.Tag = 7 then // Goto Add article
    tab := 1
  else if btn.Tag = 77 then // Goto board
    tab := 0;

  tbViews.GotoVisibleTab(tab, TTabTransition.Slide);
end;

procedure TfrmVBoards.imgArticleAMouseEnter(Sender: TObject);
begin
  btnLoadPhoto.Visible := True;
end;

procedure TfrmVBoards.imgArticleAMouseLeave(Sender: TObject);
begin
  btnLoadPhoto.Visible := False;
end;

procedure TfrmVBoards.btnLoadPhotoEnter(Sender: TObject);
begin
  odloadphoto.Filter := TBitmapCodecManager.GetFilterString;
  if odloadphoto.Execute then
  begin
    imgArticleA.Bitmap.LoadFromFile(odloadphoto.FileName);
  end;

  rctPanelArticle.SetFocus;
end;

procedure TfrmVBoards.CallDispatchEdit(Sender: TObject);
begin
  DispatchEditExecute(Sender);
end;

procedure TfrmVBoards.DispatchEditExecute(Sender: TObject);
var
  lbl: TLabel;
begin
  lbl := TLabel(Sender);
  BeginRead(TMREWS_CBoard);
  CBoard.LabelBackup := lbl;
  EndRead(TMREWS_CBoard);
  lyDispatchEdit.Visible := True;
  mmTextAA.SetFocus;
end;

procedure TfrmVBoards.DispatchEditSave(Sender: TObject);
var
  btn: TButton;
begin
  btn := TButton(Sender);
  BeginRead(TMREWS_CBoard);
  if (btn.Tag = 6) then     // Cancel
  begin
    if CBoard.LabelBackup.Tag = 5 then  // title
      CBoard.ReleaseBackup(lblTitleA)
    else if CBoard.LabelBackup.Tag = 55 then  // description
      CBoard.ReleaseBackup(lblDescA);
  end
  else if btn.Tag = 66 then // Ok edit.
  begin
    if CBoard.LabelBackup.Tag = 5 then  // title
      lblTitleA.Text := Trim(mmTextAA.Text)
    else if CBoard.LabelBackup.Tag = 55 then  // description
      lblDescA.Text := Trim(mmTextAA.Text);
  end;
  EndRead(TMREWS_CBoard);

  lyDispatchEdit.Visible := False;
  mmTextAA.Text := '';
end;

procedure TfrmVBoards.Loading(AActive: Boolean);
begin
  lyLoading.Visible := AActive;
  AniIndicator1.Enabled := AActive;
end;

end.


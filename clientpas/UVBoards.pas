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
    FArr_Articles: array[0..20] of TLayout;
  public

    { Helper for Push Article into VertScrollBox }
    procedure GetScrollContent(out ASContent: TScrollContent);
    procedure ClearVSB;
    procedure GetArticleInVsb; { TLayout }
    procedure MoveArticleForANew;

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

  CBoard.PushArticle := PushArticleIntoVSB;
  CBoard.DispatchMessage := ShowDispatchMessage;
  CBoard.ChangeTab := GotoTabsButton;

  gViewMgr.Loading := Loading;

  { Initializer }
  CBoard.GetArticles;
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
  I, II: Integer;
  // templatechild
  bmp: TImage;
  td_label: TLabel;
begin
  template := TLayout(lyArticleTemplate.Clone(lyArticleTemplate));
  template.Tag := CBoard.TagCount;
  template.Position.Y := 10;

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

  { Moviendo articles }
  if CBoard.TagCount > 10 then
    MoveArticleForANew;

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

  CBoard.AddArticle(lblTitleA.Text, lblDescA.Text, stream);
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

  CBoard.LabelBackup := lbl;

  lyDispatchEdit.Visible := True;
  mmTextAA.SetFocus;
end;

procedure TfrmVBoards.DispatchEditSave(Sender: TObject);
var
  btn: TButton;
begin
  btn := TButton(Sender);

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


  lyDispatchEdit.Visible := False;
  mmTextAA.Text := '';
end;

procedure TfrmVBoards.Loading(AActive: Boolean);
begin
  lyLoading.Visible := AActive;
  AniIndicator1.Enabled := AActive;
end;

procedure TfrmVBoards.GetArticleInVsb;
var
  I, II: Integer;
  sc: TScrollContent;
begin
  GetScrollContent(sc);

  for I := 10 to CBoard.TagCount-1 do
  begin
    for II := 0 to sc.ControlsCount-1 do
    begin
      if sc.Controls[II].Tag = I then
      begin
        FArr_Articles[I-10] := sc.Controls[II] as TLayout;
        break;
      end;
    end;
  end;
end;

procedure TfrmVBoards.MoveArticleForANew;
var
  I, last: Integer;
begin
  GetArticleInVsb;
  last := CBoard.TagCount;
  for I := 10 to last-1 do
  begin
    if I = last-1 then continue;
    FArr_Articles[I-10].Position.Y := FArr_Articles[I-10].Position.Y +
                                    FArr_Articles[I-10].Height + 10.0;
  end;
end;

end.


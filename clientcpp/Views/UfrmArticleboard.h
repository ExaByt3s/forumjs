//---------------------------------------------------------------------------

#ifndef UfrmArticleboardH
#define UfrmArticleboardH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Layouts.hpp>
#include <FMX.Types.hpp>
#include <FMX.Controls.Presentation.hpp>
#include <FMX.ListBox.hpp>
#include <FMX.ListView.Adapters.Base.hpp>
#include <FMX.ListView.Appearances.hpp>
#include <FMX.ListView.hpp>
#include <FMX.ListView.Types.hpp>
#include <FMX.Objects.hpp>
#include <FMX.StdCtrls.hpp>
//---------------------------------------------------------------------------
class TfrmArticleboard : public TForm
{
__published:	// IDE-managed Components
	TLayout *lyViewAB;
	TListView *lvDashboard;
	TListBoxItem *lbiTemplateDB;
	TImage *imgArticleImg;
	TLabel *lbltitlearticle;
	TLabel *lbldescarticle;
private:	// User declarations
public:		// User declarations
	__fastcall TfrmArticleboard(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmArticleboard *frmArticleboard;
//---------------------------------------------------------------------------
#endif

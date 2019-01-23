//---------------------------------------------------------------------------

#ifndef UfrmAppH
#define UfrmAppH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Layouts.hpp>
#include <FMX.Types.hpp>
#include <FMX.TabControl.hpp>
#include <FMX.Controls.Presentation.hpp>
#include <FMX.MultiView.hpp>
#include <FMX.Objects.hpp>
#include <FMX.StdCtrls.hpp>
//---------------------------------------------------------------------------
class TfrmApp : public TForm
{
__published:	// IDE-managed Components
	TLayout *lyViewLayout;
	TTabControl *tcMain;
	TTabItem *tbiArticlesboard;
	TTabItem *tbiChatRoom;
	TLayout *lyChatRoom;
	TLayout *lyArticlesboard;
	TLayout *lyRegionMV;
	TRectangle *rctDashboard;
	TImage *imgProfileImg;
	TButton *btnrtnprofile;
	TLabel *lblnameprofile;
private:	// User declarations
public:		// User declarations
	__fastcall TfrmApp(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmApp *frmApp;
//---------------------------------------------------------------------------
#endif

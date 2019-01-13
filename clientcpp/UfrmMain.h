//---------------------------------------------------------------------------

#ifndef UfrmMainH
#define UfrmMainH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Controls.Presentation.hpp>
#include <FMX.Edit.hpp>
#include <FMX.Layouts.hpp>
#include <FMX.StdCtrls.hpp>
#include <FMX.TabControl.hpp>
#include <FMX.Types.hpp>
//---------------------------------------------------------------------------
class TfrmMain : public TForm
{
__published:	// IDE-managed Components
	TLayout *lyMain;
	TTabControl *tbMain;
	TTabItem *tbiLogin;
	TTabItem *tbiApplication;
	TLayout *lyLeft;
	TLayout *lyRight;
	TLayout *lyPanelLogin;
	TEdit *txtusername;
	TEdit *txtpassword;
	TButton *btnstartsession;
private:	// User declarations
public:		// User declarations
	__fastcall TfrmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif

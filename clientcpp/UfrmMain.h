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
#include <FMX.Objects.hpp>
//---------------------------------------------------------------------------
class TfrmMain : public TForm
{
__published:	// IDE-managed Components
	// Main View
	TLayout *lyMain;
	TTabControl *tbMain;
	TTabItem *tbiLogin;
	TTabItem *tbiApplication;
	TLayout *lyLeft;
	TLayout *lyRight;
	// Login View
	TLayout *lyPanelLogin;
	TEdit *txtusername;
	TEdit *txtpassword;
	TButton *btnstartsession;
	TLabel *btnsignin;
	TTabControl *tbSignLogin;
	TTabItem *tbi_Login;
	TTabItem *tbi_Signin;
	// Singin View
	TLayout *lyPanelSignin;
	TEdit *txtusername_s;
	TEdit *txtemail_s;
	TEdit *txtpassword_s;
	TEdit *txtpassconfirm_s;
	TButton *btnsignin_s;
    TLabel *btnstartsession_s;
	// Prompt View
	TRectangle *rtcBackground;
	TLayout *lyMainPrompt;
	TRectangle *rctBack_end;
	TLabel *lblmessage_prompt;
	TButton *btnok_prompt;

	void __fastcall btnsigninClick(TObject *Sender);
	void __fastcall btnstartsession_sClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TfrmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif

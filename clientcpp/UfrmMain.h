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

#include "USLSession.h"

#include <memory>
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
	void __fastcall btnok_promptClick(TObject *Sender);
	void __fastcall btnstartsessionClick(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
    std::unique_ptr<SLSession> session;

public:		// User declarations
	__fastcall TfrmMain(TComponent* Owner);

	// Methods for comunications with components Views.
	// This methods pass with __closure
    void __fastcall cl_Prompt_View(const String& msg);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif

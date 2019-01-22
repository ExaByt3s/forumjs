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
#include "UViewsBase.h"

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
	// Prompt View
	TRectangle *rtcBackground;
	TLayout *lyMainPrompt;
	TRectangle *rctBack_end;
	TLabel *lblmessage_prompt;
	TButton *btnok_prompt;
	TLayout *lyApplication;
	TToolBar *tbTool;
	TButton *btnQuit;
	TLayout *lyLogin;

	void __fastcall btnok_promptClick(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall btnQuitClick(TObject *Sender);
private:	// User declarations
	//std::unique_ptr<SLSession> session;
	// Views manager
	TForm *FActiveForm;

public:		// User declarations
	__fastcall TfrmMain(TComponent* Owner);

	// Methods for comunications with components Views.
	// This methods pass with __closure
	void __fastcall cl_Prompt_View(const String& msg);
	void __fastcall cl_Dispatch_Event(EventViews ev);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif

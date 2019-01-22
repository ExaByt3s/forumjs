//---------------------------------------------------------------------------

#include <fmx.h>
#pragma hdrstop

#include "UfrmMain.h"

// views
#include "UfrmLogin.h"
#include "UfrmApp.h"
#include "UUtilities.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.fmx"
TfrmMain *frmMain;

//---------------------------------------------------------------------------
__fastcall TfrmMain::TfrmMain(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::cl_Prompt_View(const String& msg)
{
	lblmessage_prompt->Text = msg;    // translate later.
    lyMainPrompt->Visible = true;
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::btnok_promptClick(TObject *Sender)
{
	lyMainPrompt->Visible = false;
    lblmessage_prompt->Text = "";
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::FormCreate(TObject *Sender)
{
	GetView(__classid(TfrmLogin), lyLogin, FActiveForm, "lyRight");
	SLSession::Session->fn_prompt = &cl_Prompt_View;
	ViewsBase::viewsBase->fn_dispatch = &cl_Dispatch_Event;
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::cl_Dispatch_Event(EventViews ev)
{
	switch (ev)
	{
	case START_SESSION:
	{
		tbMain->GotoVisibleTab(1);
        GetView(__classid(TfrmApp), lyApplication, FActiveForm, "lyApplication");
	} break;
	}
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::btnQuitClick(TObject *Sender)
{
    exit(0);
}
//---------------------------------------------------------------------------



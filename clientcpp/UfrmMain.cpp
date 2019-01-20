//---------------------------------------------------------------------------

#include <fmx.h>
#pragma hdrstop

#include "UfrmMain.h"
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
void __fastcall TfrmMain::btnsigninClick(TObject *Sender)
{
    tbSignLogin->Next();
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::btnstartsession_sClick(TObject *Sender)
{
    tbSignLogin->Previous();
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

void __fastcall TfrmMain::btnstartsessionClick(TObject *Sender)
{
	bool pass = session->StartSession(
		txtusername->Text,
        txtpassword->Text
	);
	// Step next!
	if (pass)
        ShowMessage("En hora buena!");
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::FormCreate(TObject *Sender)
{
    session.reset(new SLSession(&cl_Prompt_View));
}
//---------------------------------------------------------------------------


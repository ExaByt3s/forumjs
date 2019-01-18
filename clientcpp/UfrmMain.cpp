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


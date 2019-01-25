//---------------------------------------------------------------------------

#include <fmx.h>
#pragma hdrstop

#include "UfrmApp.h"
#include "UViewsBase.h"

#include "UDMServer.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.fmx"
TfrmApp *frmApp;
//---------------------------------------------------------------------------
__fastcall TfrmApp::TfrmApp(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TfrmApp::btnrtnprofileClick(TObject *Sender)
{
	// for test.
    ViewsBase::viewsBase->LaunchDispatch(LOGOUT_SESSION);
}
//---------------------------------------------------------------------------

void __fastcall TfrmApp::LoadProfile()
{
    lblnameprofile->Text = dmData->UserData.Nickname;
}
//---------------------------------------------------------------------------

void __fastcall TfrmApp::FormCreate(TObject *Sender)
{
    LoadProfile();
}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------

#include <fmx.h>
#pragma hdrstop

#include "UfrmLogin.h"
#include "USLSession.h"
#include "UViewsBase.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.fmx"
TfrmLogin *frmLogin;
//---------------------------------------------------------------------------
__fastcall TfrmLogin::TfrmLogin(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfrmLogin::btnsigninClick(TObject *Sender)
{
    tbLogSign->Next();
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::btnstartsession_sClick(TObject *Sender)
{
	tbLogSign->Previous();
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::btnstartsessionClick(TObject *Sender)
{
	bool result = SLSession::Session->StartSession(
		txtusername->Text,
		txtpassword->Text
	);

	if (result)
	{
		ViewsBase::viewsBase->LaunchDispatch(START_SESSION);
	}
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::btnsignin_sClick(TObject *Sender)
{
	bool result = SLSession::Session->RegisterUser(
		txtusername_s->Text,
		txtln_s->Text,
		txtfn_s->Text,
		txtemail_s->Text,
        txtpassword_s->Text
	);

	if (result)
	{
        tbLogSign->Previous();
	}
}
//---------------------------------------------------------------------------


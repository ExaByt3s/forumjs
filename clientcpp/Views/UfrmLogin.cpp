//---------------------------------------------------------------------------

#include <fmx.h>
#pragma hdrstop

#include "UfrmLogin.h"
#include "USLSession.h"
#include "UViewsBase.h"

#include <memory>
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
    lyLeft->Visible = true;
    tbLogSign->Next();
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::btnstartsession_sClick(TObject *Sender)
{
    lyLeft->Visible = false;
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

void __fastcall TfrmLogin::rctProfilePhotoClick(TObject *Sender)
{
    odLoadPhoto->Filter = TBitmapCodecManager::GetFilterString();
	if (odLoadPhoto->Execute())
	{
		rctProfilePhoto->Fill->Bitmap->Bitmap->LoadFromFile(odLoadPhoto->FileName);
	}
}
//---------------------------------------------------------------------------


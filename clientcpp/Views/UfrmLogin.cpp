//---------------------------------------------------------------------------

#include <fmx.h>
#pragma hdrstop

#include "UfrmLogin.h"
#include "UfrmUtilities.h"
#include "Controllers/USLSession.h"
#include "UViewsBase.h"
#include "Controllers/ExceptionHandler.h"
#include "Controllers/UUtilities.h"

#include <memory>
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.fmx"
TfrmLogin *frmLogin;
//---------------------------------------------------------------------------
__fastcall TfrmLogin::TfrmLogin(TComponent* Owner)
	: TForm(Owner)
    , NotRequire(nullptr)
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
	TThread *t = TThread::CreateAnonymousThread([this]() {
		TThread::Synchronize(TThread::Current, [this]() {
            Loading(true);
		});

		auto eh = SLSession::Session->StartSession(
			txtusername->Text,
			txtpassword->Text
		);
		bool result = eh.Response;
        String msg = eh.ProcessCodError();
		TThread::Sleep(1000);

		TThread::Synchronize(nullptr, [this, result, msg]() {
			Loading(false);
			if (!result)
			{
				ViewsBase::viewsBase->PromptMsg(msg);
				return;
			}
			ViewsBase::viewsBase->LaunchDispatch(START_SESSION);
		});
	});
	t->FreeOnTerminate = true;
	t->Start();
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::btnsignin_sClick(TObject *Sender)
{
	TThread *t = TThread::CreateAnonymousThread([this]() {
        TThread::Synchronize(TThread::Current, [this]() {
            Loading(true);
		});

		auto eh = SLSession::Session->RegisterUser(
			txtusername_s->Text,
			txtln_s->Text,
			txtfn_s->Text,
			txtemail_s->Text,
			txtpassword_s->Text,
            crtProfilePhoto->Fill->Bitmap->Bitmap
		);

		bool result = eh.Response;
		String msg = eh.ProcessCodError();

		TThread::Sleep(1000);

		TThread::Synchronize(TThread::Current, [this, result, msg]() {
			Loading(false);
			if (!result)
			{
				ViewsBase::viewsBase->PromptMsg(msg);
				return;
			}
			btnstartsession_sClick(nullptr); // Go to login.
		});
	});
	t->FreeOnTerminate = true;
	t->Start();
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::Loading(bool interruptor)
{
    lyLoading->Visible = interruptor;
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::FormCreate(TObject *Sender)
{
	GetView(__classid(TfrmUtilities), lyLoading, NotRequire, "lyViewLoading");
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::FormDestroy(TObject *Sender)
{
    NotRequire->DisposeOf();
}
//---------------------------------------------------------------------------

void __fastcall TfrmLogin::crtProfilePhotoClick(TObject *Sender)
{
    odLoadPhoto->Filter = TBitmapCodecManager::GetFilterString();
	if (odLoadPhoto->Execute())
	{
		crtProfilePhoto->Fill->Bitmap->Bitmap->LoadFromFile(odLoadPhoto->FileName);
	}
}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------

#include <fmx.h>
#pragma hdrstop

#include "UfrmMain.h"

// views
#include "UfrmLogin.h"
#include "UfrmApp.h"
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
	//session.reset(new SLSession(&cl_Prompt_View));
	GetView(__classid(TfrmLogin), lyRight);
	SLSession::Session->fn_prompt = &cl_Prompt_View;
	ViewsBase::viewsBase->fn_dispatch = &cl_Dispatch_Event;
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::GetView(const TComponentClass aForm, TLayout *Parent)
{
	if ((FActiveForm != nullptr) &&
		(FActiveForm->ClassName != aForm->ClassName))
	{
        Parent->Children->DisposeOf();
        /*
		for (int i = Parent->ControlsCount - 1; i >= 0; --i)
		{
			Parent->RemoveObject(Parent->Controls[i]);
		} */
	}

	FActiveForm->DisposeOf();
	FActiveForm = nullptr;

	Application->CreateForm(aForm, &FActiveForm);
    Parent->AddObject(dynamic_cast<TLayout*>(FActiveForm->FindComponent("lyViewLayout")));
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::cl_Dispatch_Event(EventViews ev)
{
	switch (ev)
	{
	case START_SESSION:
	{
		tbMain->GotoVisibleTab(1);
        GetView(__classid(TfrmApp), lyApplication);
	} break;
	}
}
//---------------------------------------------------------------------------


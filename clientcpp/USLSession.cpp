//---------------------------------------------------------------------------

#pragma hdrstop

#include "USLSession.h"
#include "UDataModule.h"
#include "ExceptionHandler.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

SLSession::SLSession(_Prompt_View fn)
{
    fn_prompt = fn;
}

SLSession::~SLSession()
{
}

bool SLSession::StartSession(refStr nickname, refStr password)
{
	try
	{
		bool pass = dmData->Login(nickname, password);
        return pass;
	}
	catch (ExceptionHandler& e)
	{
		#ifdef _DEBUG
        e.ShowMsgException();
		#endif
        fn_prompt(e.ProcessCodError());
        return false;
	}
}


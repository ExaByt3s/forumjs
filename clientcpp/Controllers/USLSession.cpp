//---------------------------------------------------------------------------

#pragma hdrstop

#include "USLSession.h"
#include "../Services/UDMServer.h"
#include "ExceptionHandler.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

SLSession *SLSession::Session = new SLSession();

SLSession::SLSession()
{
    fn_prompt = nullptr;
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
	//	e.ShowMsgException();
        fn_prompt(e.ProcessCodError());
        return false;
	}
}

bool SLSession::RegisterUser(refStr nickname, refStr lastname,
				  refStr firstname, refStr email, refStr password)
{
	try
	{
		bool pass = dmData->SignIn(nickname, lastname, firstname, email, password);
		return pass;
	}
	catch (ExceptionHandler& e)
	{
        fn_prompt(e.ProcessCodError());
        return false;
	}
}


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
}

SLSession::~SLSession()
{
}

ExceptionHandler SLSession::StartSession(refStr nickname, refStr password)
{
	return dmData->Login(nickname, password);
}

ExceptionHandler SLSession::RegisterUser(refStr nickname, refStr lastname,
				  refStr firstname, refStr email, refStr password, TBitmap *bm)
{
	return dmData->SignIn(nickname, lastname, firstname, email, password, bm);
}


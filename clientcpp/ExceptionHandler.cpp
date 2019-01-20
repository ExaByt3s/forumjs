//---------------------------------------------------------------------------

#pragma hdrstop

#include "ExceptionHandler.h"
#include "UUtilities.h"
#include <FMX.Dialogs.hpp>
//---------------------------------------------------------------------------
#pragma package(smart_init)

ExceptionHandler::ExceptionHandler()
{
	codError = 0;
    method = "";
}

ExceptionHandler::ExceptionHandler(int CodError, refUStr Method)
{
	codError = CodError;
    method = Method;
}

String ExceptionHandler::ProcessCodError()
{
    String msg;
    switch (codError)
	{
		case ERROR_TOKEN:
			msg = "";
			break;
		case USER_NOT_FOUND:
			msg = "";
			break;
		case DATA_INCOMPLENT:
			msg = "";
			break;
		case JSON_INVALID:
			msg = "";
			break;
		case DB_EMPTY:
			msg = "";
			break;
		case INCORRECT_DATA:
			msg = "";
			break;
		case ONLY_FOR_DEVELOPERS:
			msg = "";
			break;
		case ERROR_QUERY:
			msg = "";
			break;
        case CONNECTION_ERROR:
			msg = "";
			break;
		default:
			msg = "Unknow";
            break;
	}
    return msg;
}

#ifdef _DEBUG
void ExceptionHandler::ShowMsgException()
{
	ShowMessage("Method: " + method +
				"\nCodError: " + codError +
				"\nMessage: " + ProcessCodError());
}
#endif


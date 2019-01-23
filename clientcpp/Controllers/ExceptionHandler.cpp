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
			msg = "Error token!";
			break;
		case USER_NOT_FOUND:
			msg = "User not found!";
			break;
		case DATA_INCOMPLENT:
			msg = "Data incompleta!";
			break;
		case JSON_INVALID:
			msg = "JSON Invalid!";
			break;
		case DB_EMPTY:
			msg = "DB empty!";
			break;
		case INCORRECT_DATA:
			msg = "Datos incorrectos!";
			break;
		case USER_EMAIL_EXISTS:
			msg = "User or Email Exists!";
			break;
		case ONLY_FOR_DEVELOPERS:
			msg = "Only for Developers!";
			break;
		case ERROR_QUERY:
			msg = "Error Query!";
			break;
		case CONNECTION_ERROR:
			msg = "Connection Error!";
			break;
		default:
			msg = "Unknow";
            break;
	}
    return msg;
}

void ExceptionHandler::ShowMsgException()
{
	ShowMessage("Method: " + method +
				"\nCodError: " + codError +
				"\nMessage: " + ProcessCodError());
}


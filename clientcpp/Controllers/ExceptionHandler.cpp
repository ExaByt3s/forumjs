//---------------------------------------------------------------------------

#pragma hdrstop

#include "ExceptionHandler.h"
#include "UUtilities.h"
#include <FMX.Dialogs.hpp>
//---------------------------------------------------------------------------
#pragma package(smart_init)

ExceptionHandler::ExceptionHandler()
	: _response(false)
	, _codError(0)
	, _method("")
	, _resource(nullptr)
{
}

ExceptionHandler::ExceptionHandler(ExceptionHandler&& eh)
{
    *this = std::move(eh);
}

ExceptionHandler::ExceptionHandler(bool res)
	: _response(res)
	, _codError(0)
	, _method("")
	, _resource(nullptr)
{
}

ExceptionHandler::ExceptionHandler(bool res, int CodError, refUStr Method)
	: _response(res)
	, _codError(CodError)
	, _method(Method)
	, _resource(nullptr)
{
}

ExceptionHandler::ExceptionHandler(bool res, void* data)
	: _response(res)
	, _codError(0)
	, _method("")
	, _resource(data)
{
}

ExceptionHandler::~ExceptionHandler()
{
	if (_resource) delete _resource;
    _resource = nullptr;
}

ExceptionHandler& ExceptionHandler::operator=(ExceptionHandler&& eh)
{
	Response = eh.Response;
	CodError = eh.CodError;
	_method = eh._method;
    memcpy(Resource, eh.Resource, sizeof(*eh.Resource));
    return *this;
}

String ExceptionHandler::ProcessCodError()
{
    String msg;
    switch (_codError)
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
	ShowMessage("Method: " + _method +
				"\nCodError: " + _codError +
				"\nMessage: " + ProcessCodError());
}


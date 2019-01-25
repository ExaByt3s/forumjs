//---------------------------------------------------------------------------

#ifndef ExceptionHandlerH
#define ExceptionHandlerH
//---------------------------------------------------------------------------

#include <System.Classes.hpp>

class ExceptionHandler
{
	using refUStr = const String&;
public:
	ExceptionHandler();
    ExceptionHandler(ExceptionHandler&& eh);
	ExceptionHandler(bool res); 								// Repuestas
	ExceptionHandler(bool res, int CodError, refUStr Method); 	// Excepciones

    ExceptionHandler& operator=(ExceptionHandler&& eh);

	void ShowMsgException();
	String ProcessCodError();

	__property bool Response = { read=_response, write=_response };
    __property int CodError = { read=_codError, write=_codError };

private:
	bool _response;
	int _codError;
	String _method;
};

#endif

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
	ExceptionHandler(int CodError, refUStr Method);

#ifdef _DEBUG
    void ShowMsgException();
#endif
    String ProcessCodError();
private:
	int codError;
    String method;
};

#endif

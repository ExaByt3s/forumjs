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

	void ShowMsgException();
    String ProcessCodError();
private:
	int codError;
    String method;
};

#endif

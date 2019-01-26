//---------------------------------------------------------------------------

#ifndef USLSessionH
#define USLSessionH

#include <System.Classes.hpp>
#include "../Models/UUser.h"

#include "ExceptionHandler.h"
//---------------------------------------------------------------------------

class SLSession
{
    using refStr = const UnicodeString&;
public:
    static SLSession *Session;
	SLSession();
	~SLSession();

	ExceptionHandler StartSession(refStr nickname, refStr password);
	ExceptionHandler RegisterUser(refStr nickname, refStr lastname,
				  refStr firstname, refStr email, refStr password);

	// ExceptionHandler for hilo
	ExceptionHandler _th_eh;
};

#endif

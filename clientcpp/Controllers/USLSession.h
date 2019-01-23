//---------------------------------------------------------------------------

#ifndef USLSessionH
#define USLSessionH

#include <System.Classes.hpp>
#include "../Models/UUser.h"
//---------------------------------------------------------------------------

// closure for views
using _Prompt_View = void __fastcall(__closure *)(const String&);

class SLSession
{
    using refStr = const String&;
public:
    static SLSession *Session;
	SLSession();
	~SLSession();

	bool StartSession(refStr nickname, refStr password);
	bool RegisterUser(refStr nickname, refStr lastname,
				  refStr firstname, refStr email, refStr password);

    // closures
	_Prompt_View fn_prompt;
};

#endif

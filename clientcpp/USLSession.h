//---------------------------------------------------------------------------

#ifndef USLSessionH
#define USLSessionH

#include <System.Classes.hpp>
#include "UModels.h"
//---------------------------------------------------------------------------

// closure for views
typedef void __fastcall(__closure *_Prompt_View)(const String&);

class SLSession
{
    using refStr = const String&;
public:
	SLSession(_Prompt_View fn);
	~SLSession();

	bool StartSession(refStr nickname, refStr password);

private:
    _Prompt_View fn_prompt;
};

#endif

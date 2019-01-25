//---------------------------------------------------------------------------

#ifndef UViewsBaseH
#define UViewsBaseH

#include <System.Classes.hpp>

#include <memory>

//---------------------------------------------------------------------------

// event type
enum EventViews
{
	START_SESSION = 0,
    LOGOUT_SESSION,
};

// closure
using DispatchEvent = void __fastcall(__closure *)(EventViews);
using PromptMessage = void __fastcall(__closure *)(const String&);

class ViewsBase
{
public:
    static ViewsBase *viewsBase;
	ViewsBase();
	~ViewsBase();

	void LaunchDispatch(EventViews ev);
    void PromptMsg(const String& msg);

	// closure
	DispatchEvent fn_dispatch;
	PromptMessage fn_prompt;
};



#endif

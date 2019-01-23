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
};

// closure
using DispatchEvent = void __fastcall(__closure *)(EventViews);

class ViewsBase
{
public:
    static ViewsBase *viewsBase;
	ViewsBase();
	~ViewsBase();

    void LaunchDispatch(EventViews ev);

	DispatchEvent fn_dispatch;
};



#endif

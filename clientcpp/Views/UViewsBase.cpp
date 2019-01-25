//---------------------------------------------------------------------------

#pragma hdrstop

#include "UViewsBase.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

ViewsBase *ViewsBase::viewsBase = new ViewsBase();

ViewsBase::ViewsBase()
{
}

ViewsBase::~ViewsBase()
{
}

void ViewsBase::LaunchDispatch(EventViews ev)
{
    fn_dispatch(ev);
}

void ViewsBase::PromptMsg(const String& msg)
{
    fn_prompt(msg);
}


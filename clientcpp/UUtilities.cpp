//---------------------------------------------------------------------------

#pragma hdrstop

#include "UUtilities.h"
#include <System.Hash.hpp>
//---------------------------------------------------------------------------
#pragma package(smart_init)

String MakeHash512(const String& text)
{
	return THashSHA2::GetHashString(text.LowerCase(),
		THashSHA2::TSHA2Version::SHA512).LowerCase();
}

void __fastcall GetView(const TComponentClass aForm, TLayout *Parent,
						TForm *ref, const String& component)
{
	if ((ref != nullptr) &&
		(ref->ClassName != aForm->ClassName))
	{
        Parent->Children->DisposeOf();
	}

	ref->DisposeOf();
	ref = nullptr;

	Application->CreateForm(aForm, &ref);
	Parent->AddObject(dynamic_cast<TLayout*>(ref->FindComponent(component)));
}


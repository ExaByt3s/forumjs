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


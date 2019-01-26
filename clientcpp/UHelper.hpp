// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UHelper.pas' rev: 32.00 (Windows)

#ifndef UhelperHPP
#define UhelperHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.JSON.hpp>
#include <System.Classes.hpp>
#include <System.StrUtils.hpp>
#include <System.SysUtils.hpp>
#include <IdCoderMIME.hpp>

//-- user supplied -----------------------------------------------------------

namespace Uhelper
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS THelpJArray;
class DELPHICLASS TEncryp;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION THelpJArray : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	static System::Json::TJSONObject* __fastcall GetJArrayRow(System::Json::TJSONValue* org, System::UnicodeString val);
public:
	/* TObject.Create */ inline __fastcall THelpJArray(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~THelpJArray(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TEncryp : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	static System::UnicodeString __fastcall B64Encode(System::Classes::TBytesStream* bs);
	static System::Classes::TBytesStream* __fastcall B64Decode(System::UnicodeString src);
public:
	/* TObject.Create */ inline __fastcall TEncryp(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TEncryp(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define Code64 L"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuv"\
	L"wxyz+/"
}	/* namespace Uhelper */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UHELPER)
using namespace Uhelper;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UhelperHPP

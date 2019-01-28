//---------------------------------------------------------------------------

#ifndef UUtilitiesH
#define UUtilitiesH

#include <System.Classes.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Layouts.hpp>
//---------------------------------------------------------------------------

// CODE ERRORS
enum CODE_ERROR
{
	SUCCESSFULLY = 0,
	ERROR_TOKEN = -1,
	USER_NOT_FOUND = -2,
	DATA_INCOMPLENT = -3,
	JSON_INVALID = -4,
	DB_EMPTY = -5,
	INCORRECT_DATA = -6,
    USER_EMAIL_EXISTS = -7,
	ONLY_FOR_DEVELOPERS = -98,
	ERROR_QUERY = -99,
    CONNECTION_ERROR = -999,
};

// define
#define SAFE_POINTER(x) if ((x)) delete (x); (x) = nullptr

// Hash 512
String MakeHash512(const String& text);

// Get Views
void __fastcall GetView(const TComponentClass aForm, TLayout *Parent,
						TForm *ref, const String& component);

// Copy two pointer
template<typename T>
void __fastcall MemCopy(void *dst, void *src)
{
	memcpy(dst, src, sizeof(T));
}

#endif

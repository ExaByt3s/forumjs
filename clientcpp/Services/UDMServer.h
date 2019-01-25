//---------------------------------------------------------------------------

#ifndef UDMServerH
#define UDMServerH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <Data.Bind.Components.hpp>
#include <Data.Bind.ObjectScope.hpp>
#include <REST.Client.hpp>
#include <REST.Types.hpp>
#include <IPPeerClient.hpp>

#include <memory>
#include <mutex>

#include "../Controllers/ExceptionHandler.h"
#include "../Models/UUser.h"
//---------------------------------------------------------------------------

// using
using UPtrJSONObject = std::unique_ptr<TJSONObject>;
using refStr = const String&;

class TdmData : public TDataModule
{
__published:	// IDE-managed Components
private:	// User declarations
	std::mutex _m_execrest;
    User _user;

	// methods REQUEST REST API
	UPtrJSONObject ExecREST(String method, const UPtrJSONObject& body);
public:		// User declarations
	__fastcall TdmData(TComponent* Owner);

    // Login & Signin
	ExceptionHandler Login(const String& nickname, const String& password);
	ExceptionHandler SignIn(refStr nickname, refStr lastname,
				  refStr firstname, refStr email, refStr password);

	// Articles

	// propertys
	__property User UserData = { read=_user };
};
//---------------------------------------------------------------------------
extern PACKAGE TdmData *dmData;
//---------------------------------------------------------------------------
#endif

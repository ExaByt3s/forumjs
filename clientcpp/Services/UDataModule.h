//---------------------------------------------------------------------------

#ifndef UDataModuleH
#define UDataModuleH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <Data.Bind.Components.hpp>
#include <Data.Bind.ObjectScope.hpp>
#include <REST.Client.hpp>
#include <REST.Types.hpp>
#include <IPPeerClient.hpp>
#include <memory>

#include "../Models/UUser.h"
//---------------------------------------------------------------------------

// using
using UPtrJSONObject = std::unique_ptr<TJSONObject>;
using refStr = const String&;

class TdmData : public TDataModule
{
__published:	// IDE-managed Components
private:	// User declarations
    User _user;

	// methods REQUEST REST API
	UPtrJSONObject ExecREST(String method, const UPtrJSONObject& body);
public:		// User declarations
	__fastcall TdmData(TComponent* Owner);

    // Login & Signin
	bool Login(const String& nickname, const String& password);
	bool SignIn(refStr nickname, refStr lastname,
				  refStr firstname, refStr email, refStr password);
};
//---------------------------------------------------------------------------
extern PACKAGE TdmData *dmData;
//---------------------------------------------------------------------------
#endif

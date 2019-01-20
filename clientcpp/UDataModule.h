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

#include "UModels.h"
//---------------------------------------------------------------------------

// using
using UPtrJSONObject = std::unique_ptr<TJSONObject>;

class TdmData : public TDataModule
{
__published:	// IDE-managed Components
private:	// User declarations
    User _user;

	// methods
	UPtrJSONObject ExecREST(String method, const UPtrJSONObject& body);
public:		// User declarations
	__fastcall TdmData(TComponent* Owner);

    bool Login(const String& nickname, const String& password);
};
//---------------------------------------------------------------------------
extern PACKAGE TdmData *dmData;
//---------------------------------------------------------------------------
#endif

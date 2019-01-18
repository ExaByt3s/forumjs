//---------------------------------------------------------------------------


#pragma hdrstop

#include "UDataModule.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma classgroup "FMX.Controls.TControl"
#pragma resource "*.dfm"
TdmData *dmData;
//---------------------------------------------------------------------------
__fastcall TdmData::TdmData(TComponent* Owner)
	: TDataModule(Owner)
{
}
//---------------------------------------------------------------------------

UPtrJSONObject TdmData::ExecREST(String method, UPtrJSONObject body)
{
	std::unique_ptr<TRESTClient> rClient(new TRESTClient(nullptr));
	std::unique_ptr<TRESTRequest> rRequest(new TRESTRequest(nullptr));
	std::unique_ptr<TRESTResponse> rResponse(new TRESTResponse(nullptr));
	rClient->BaseURL = "http://localhost:3000/api/sm/";
	rRequest->Client = rClient.get();
	rRequest->Response = rResponse.get();
	rRequest->Method = TRESTRequestMethod::rmPOST;
	rRequest->Resource = method;
	rRequest->SynchronizedEvents = false;
	rRequest->Timeout = 10000;
	rRequest->Body->Add(body.get());
	try
	{
		rRequest->Execute();
		int codError;
		if (!rResponse->JSONValue->TryGetValue<int>("CodError", codError))
		{
			throw new Exception("Invalid server response");
		}

		TJSONObject *resobj = dynamic_cast<TJSONObject*>(rResponse->JSONValue->Clone());
		UPtrJSONObject resptr(resobj);
		return std::move(resptr);
	}
	catch (Exception& e)
	{
		UPtrJSONObject mr(new TJSONObject());
		mr->AddPair("CodError", IntToStr(-999));
		return mr;
	}
}
//---------------------------------------------------------------------------

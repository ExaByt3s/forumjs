//---------------------------------------------------------------------------


#pragma hdrstop

#include "UDMServer.h"
#include "UUtilities.h"
#include "ExceptionHandler.h"
#include <FMX.Dialogs.hpp>
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

UPtrJSONObject TdmData::ExecREST(String method, const UPtrJSONObject& body)
{
	std::unique_ptr<TRESTClient> rClient(new TRESTClient(this));
	std::unique_ptr<TRESTRequest> rRequest(new TRESTRequest(this));
	std::unique_ptr<TRESTResponse> rResponse(new TRESTResponse(this));
	rClient->BaseURL = "http://localhost:3000/api/sm/";
	rRequest->Client = rClient.get();
	rRequest->Response = rResponse.get();
	rRequest->Method = TRESTRequestMethod::rmPOST;
	rRequest->Resource = method;
	rRequest->SynchronizedEvents = false;
	rRequest->Timeout = 10000;
	rRequest->Body->Add(body.get());
	int codError = 0;
	try
	{
		rRequest->Execute();
		if (!rResponse->JSONValue->TryGetValue<int>("codError", codError))
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
		mr->AddPair("codError", IntToStr(CONNECTION_ERROR));
		return std::move(mr);
	}
}
//---------------------------------------------------------------------------

bool TdmData::Login(const String& nickname, const String& password)
{
	UPtrJSONObject body(new TJSONObject());
	UPtrJSONObject res;
	String pass = MakeHash512(password);
	body->AddPair("nickname", nickname.LowerCase());
	body->AddPair("password", pass);
	res.reset(ExecREST("login", body).release());
	int codError = StrToInt(res->GetValue("codError")->Value());

	try
	{
		if (codError)
			throw ExceptionHandler();

		_user.Nickname = nickname;
		_user.Password = pass;
		_user.Token = res->GetValue("token")->Value();
        return true;
	}
	catch (ExceptionHandler& e)
	{
		throw ExceptionHandler(codError, "TdmData::Login");
    }
}
//---------------------------------------------------------------------------

bool TdmData::SignIn(refStr nickname, refStr lastname,
						refStr firstname, refStr email, refStr password)
{
    UPtrJSONObject body(new TJSONObject());
	UPtrJSONObject res;
	String pass = MakeHash512(password);
	body->AddPair("nickname", nickname.LowerCase());
	body->AddPair("lastname", lastname.LowerCase());
	body->AddPair("firstname", firstname.LowerCase());
	body->AddPair("email", email);
	body->AddPair("password", pass);
	res.reset(ExecREST("signin", body).release());
	int codError = StrToInt(res->GetValue("codError")->Value());

	try
	{
        if (codError)
			throw ExceptionHandler();

		return true;
	}
	catch (ExceptionHandler& e)
	{
		throw ExceptionHandler(codError, "TdmData::SignIn");
	}
}
//---------------------------------------------------------------------------


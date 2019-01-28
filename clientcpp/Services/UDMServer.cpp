//---------------------------------------------------------------------------


#pragma hdrstop

#include "UDMServer.h"
#include "UUtilities.h"
#include "ExceptionHandler.h"
#include "../UHelper.hpp"

#include <FMX.Dialogs.hpp>
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma classgroup "FMX.Controls.TControl"
#pragma resource "*.dfm"
TdmData *dmData;
//---------------------------------------------------------------------------
__fastcall TdmData::TdmData(TComponent* Owner)
	: TDataModule(Owner)
	, _user(new User())
{
}
//---------------------------------------------------------------------------

UPtrJSONObject TdmData::ExecREST(String method, const UPtrJSONObject& body)
{
    std::lock_guard<std::mutex> lock(_m_execrest);
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

ExceptionHandler TdmData::Login(refStr nickname, refStr password)
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

		_user->Id = StrToInt(res->GetValue("id")->Value());
		_user->Nickname = nickname;
		_user->Password = pass;
		_user->Token = res->GetValue("token")->Value();

		GetUserPhoto(_User()->Id);

		return ExceptionHandler(true);
	}
	catch (ExceptionHandler& e)
	{
		return ExceptionHandler(false, codError, "TdmData::Login");
    }
}
//---------------------------------------------------------------------------

ExceptionHandler TdmData::SignIn(refStr nickname, refStr lastname,
						refStr firstname, refStr email, refStr password, TBitmap *bm)
{
    UPtrJSONObject body(new TJSONObject());
	UPtrJSONObject res;
	String pass = MakeHash512(password);
	body->AddPair("nickname", nickname.LowerCase());
	body->AddPair("lastname", lastname.LowerCase());
	body->AddPair("firstname", firstname.LowerCase());
	body->AddPair("email", email);
	body->AddPair("password", pass);
	std::unique_ptr<TBytesStream> b(new TBytesStream(TBytes()));
	bm->SaveToStream(b.get());
	body->AddPair("image", TEncryp::B64Encode(b.get()));
	res.reset(ExecREST("signin", body).release());
	int codError = StrToInt(res->GetValue("codError")->Value());

	try
	{
		if (codError)
			throw ExceptionHandler();

		return ExceptionHandler(true);
	}
	catch (ExceptionHandler& e)
	{
		return ExceptionHandler(false, codError, "TdmData::SignIn");
	}
}
//---------------------------------------------------------------------------

ExceptionHandler TdmData::GetUserPhoto(int id)
{
	UPtrJSONObject body(new TJSONObject());
	UPtrJSONObject res;
	body->AddPair("id", _User()->Id);
	body->AddPair("token", _User()->Token);
	body->AddPair("id_usr", id);
	res.reset(ExecREST("getuserphoto", body).release());
    int codError = StrToInt(res->GetValue("codError")->Value());

    try
	{
		if (codError)
			throw ExceptionHandler();

		std::unique_ptr<TBytesStream> b(TEncryp::B64Decode(res->GetValue("image")->Value()));
        b->Position = 0;
		std::unique_ptr<TBitmap> bmp(new TBitmap());
		bmp->LoadFromStream(b.get());
		_user->Image = bmp.release();
		return ExceptionHandler(true);
	}
	catch (ExceptionHandler& e)
	{
		return ExceptionHandler(false, codError, "TdmData::GetUserPhoto");
	}
}
//---------------------------------------------------------------------------

void __fastcall TdmData::DataModuleDestroy(TObject *Sender)
{
	if (_user) delete _user;
	_user = nullptr;
}
//---------------------------------------------------------------------------

User* const TdmData::_User() const
{
    return _user;
}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------

#pragma hdrstop

#include "UUser.h"
#include "../Controllers/UUtilities.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

User::User()
	: EntityBase()
	, _nickname("")
	, _password("")
	, _email("")
	, _token("")
{
}


User::User(User&& user)
	: EntityBase()
	, _nickname("")
	, _password("")
	, _email("")
	, _token("")
{
	*this = std::move(user);
}

User::User(int id, int range, refStr nickname, refStr password,
		refStr email, refStr token, TBitmap *img)
	: EntityBase(id, range, img)
	, _nickname(nickname)
	, _password(password)
	, _email(email)
	, _token(token)
{
}

User::~User()
{
}

User& User::operator=(User&& user)
{
	this->~User();
	Id = user.Id;
	Range = user.Range;
    MemCopy<TBitmap>(Image, user.Image);
	Nickname = user.Nickname;
	Password = user.Password;
	Email = user.Email;
	Token = user.Token;
	return *this;
}


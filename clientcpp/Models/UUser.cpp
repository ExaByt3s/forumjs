//---------------------------------------------------------------------------

#pragma hdrstop

#include "UUser.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

User::User()
	: id{0}
	, range{0}
	, nickname{""}
	, password{""}
	, email{""}
	, token{""}
{
}

User::User(const User& user)
{
	id = user.id;
	range = user.range;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
}

User::User(User&& user)
{
	id = user.id;
	range = user.range;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
}

User::User(unsigned id, int range, refStr nname, refStr pass, refStr em, refStr tk)
	: id{id}
	, range{range}
	, nickname{nname}
	, password{pass}
	, email{em}
    , token{tk}
{
}

User& User::operator=(const User& user)
{
	id = user.id;
	range = user.range;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
    return *this;
}

User& User::operator=(User&& user)
{
	id = user.id;
    range = user.range;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
    return *this;
}


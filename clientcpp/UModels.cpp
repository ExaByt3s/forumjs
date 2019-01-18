//---------------------------------------------------------------------------

#pragma hdrstop

#include "UModels.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

User::User()
	: id{0}
	, nickname{""}
	, password{""}
	, email{""}
	, token{""}
{
}

User::User(const User& user)
{
    id = user.id;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
}

User::User(User&& user)
{
	id = user.id;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
}

User::User(unsigned id, String nname, String pass, String em, String tk)
	: id{id}
	, nickname{nname}
	, password{pass}
	, email{em}
    , token{tk}
{
}

User& User::operator=(const User& user)
{
	id = user.id;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
    return *this;
}

User& User::operator=(User&& user)
{
    id = user.id;
	nickname = user.nickname;
	password = user.password;
	email = user.email;
	token = user.token;
    return *this;
}

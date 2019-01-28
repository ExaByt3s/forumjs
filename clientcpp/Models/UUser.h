//---------------------------------------------------------------------------

#ifndef UUserH
#define UUserH
#include <System.Classes.hpp>
#include <FMX.Graphics.hpp>

#include "UEntityBase.h"

#include <memory>
//---------------------------------------------------------------------------

// using
using refStr = const String&;

class User : public EntityBase
{
public:
	User();
	User(User&& user);
	User(int id, int range, refStr nickname, refStr password,
		 refStr email, refStr token, TBitmap *img);
	virtual ~User();

	User& operator=(User&& user);

	__property String Nickname = { read=_nickname, write=_nickname };
	__property String Password = { read=_password, write=_password };
	__property String Email = { read=_email, write=_email };
	__property String Token = { read=_token, write=_token };

private:
	String _nickname;
	String _password;
	String _email;
	String _token;
};

#endif

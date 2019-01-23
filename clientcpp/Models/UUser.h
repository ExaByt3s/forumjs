//---------------------------------------------------------------------------

#ifndef UUserH
#define UUserH
#include <System.Classes.hpp>
//---------------------------------------------------------------------------

// using
using refStr = const String&;

struct User
{
	unsigned id;
    int range;
	String nickname;
	String password;
	String email;
    String token;

	User();
	User(User&& user);
	User(const User& user);
	User(unsigned id, int range, refStr nickname, refStr password, refStr email, refStr token);

	User& operator=(const User& user);
    User& operator=(User&& user);
};

#endif

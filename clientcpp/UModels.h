//---------------------------------------------------------------------------

#ifndef UModelsH
#define UModelsH

#include <System.Classes.hpp>
//---------------------------------------------------------------------------

struct User
{
	unsigned id;
	String nickname;
	String password;
	String email;
    String token;

	User();
	User(User&& user);
	User(const User& user);
	User(unsigned id, String nickname, String password, String email, String token);

	User& operator=(const User& user);
    User& operator=(User&& user);
};

#endif

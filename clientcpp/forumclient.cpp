//---------------------------------------------------------------------------

#include <fmx.h>
#ifdef _WIN32
#include <tchar.h>
#endif
#pragma hdrstop
#include <System.StartUpCopy.hpp>
//---------------------------------------------------------------------------
USEFORM("Views\UfrmApp.cpp", frmApp);
USEFORM("UfrmMain.cpp", frmMain);
USEFORM("Services\UDMServer.cpp", dmData); /* TDataModule: File Type */
USEFORM("Views\UfrmUtilities.cpp", frmUtilities);
USEFORM("Views\UfrmLogin.cpp", frmLogin);
USEFORM("Views\UfrmArticleboard.cpp", frmArticleboard);
//---------------------------------------------------------------------------
extern "C" int FMXmain()
{
	try
	{
		Application->Initialize();
		Application->CreateForm(__classid(TfrmMain), &frmMain);
		Application->Run();
	}
	catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	catch (...)
	{
		try
		{
			throw Exception("");
		}
		catch (Exception &exception)
		{
			Application->ShowException(&exception);
		}
	}
	return 0;
}
//---------------------------------------------------------------------------

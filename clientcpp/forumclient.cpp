//---------------------------------------------------------------------------

#include <fmx.h>
#ifdef _WIN32
#include <tchar.h>
#endif
#pragma hdrstop
#include <System.StartUpCopy.hpp>
//---------------------------------------------------------------------------
USEFORM("Services\UDMServer.cpp", dmData); /* TDataModule: File Type */
USEFORM("UfrmMain.cpp", frmMain);
USEFORM("Views\UfrmLogin.cpp", frmLogin);
USEFORM("Views\UfrmArticleboard.cpp", frmArticleboard);
USEFORM("Views\UfrmApp.cpp", frmApp);
//---------------------------------------------------------------------------
extern "C" int FMXmain()
{
	try
	{
		Application->Initialize();
		Application->CreateForm(__classid(TfrmMain), &frmMain);
		Application->CreateForm(__classid(TfrmApp), &frmApp);
		Application->CreateForm(__classid(TfrmArticleboard), &frmArticleboard);
		Application->CreateForm(__classid(TfrmLogin), &frmLogin);
		Application->CreateForm(__classid(TdmData), &dmData);
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

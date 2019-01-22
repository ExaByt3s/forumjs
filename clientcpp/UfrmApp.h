//---------------------------------------------------------------------------

#ifndef UfrmAppH
#define UfrmAppH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Layouts.hpp>
#include <FMX.Types.hpp>
//---------------------------------------------------------------------------
class TfrmApp : public TForm
{
__published:	// IDE-managed Components
	TLayout *lyViewLayout;
private:	// User declarations
public:		// User declarations
	__fastcall TfrmApp(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmApp *frmApp;
//---------------------------------------------------------------------------
#endif

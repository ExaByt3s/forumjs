//---------------------------------------------------------------------------

#ifndef UfrmArticleboardH
#define UfrmArticleboardH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Layouts.hpp>
#include <FMX.Types.hpp>
//---------------------------------------------------------------------------
class TfrmArticleboard : public TForm
{
__published:	// IDE-managed Components
	TLayout *lyViewAB;
	TVertScrollBox *vsbBoard;
private:	// User declarations
public:		// User declarations
	__fastcall TfrmArticleboard(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmArticleboard *frmArticleboard;
//---------------------------------------------------------------------------
#endif

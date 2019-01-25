//---------------------------------------------------------------------------

#ifndef UfrmUtilitiesH
#define UfrmUtilitiesH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Layouts.hpp>
#include <FMX.TabControl.hpp>
#include <FMX.Types.hpp>
#include <FMX.Objects.hpp>
#include <FMX.StdCtrls.hpp>
//---------------------------------------------------------------------------
class TfrmUtilities : public TForm
{
__published:	// IDE-managed Components
	TTabControl *tbUtils;
	TTabItem *tbiLoading;
	TLayout *lyViewLoading;
	TRectangle *rctBackground;
	TAniIndicator *AniIndicator1;
private:	// User declarations
public:		// User declarations
	__fastcall TfrmUtilities(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmUtilities *frmUtilities;
//---------------------------------------------------------------------------
#endif

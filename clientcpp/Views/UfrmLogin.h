//---------------------------------------------------------------------------

#ifndef UfrmLoginH
#define UfrmLoginH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <FMX.Controls.hpp>
#include <FMX.Forms.hpp>
#include <FMX.Layouts.hpp>
#include <FMX.TabControl.hpp>
#include <FMX.Types.hpp>
#include <FMX.Controls.Presentation.hpp>
#include <FMX.Edit.hpp>
#include <FMX.StdCtrls.hpp>
#include <FMX.Dialogs.hpp>
#include <FMX.Objects.hpp>

//---------------------------------------------------------------------------
class TfrmLogin : public TForm
{
__published:	// IDE-managed Components
	TLayout *lyViewLayout;
	TTabControl *tbLogSign;
	TTabItem *tbiLogin;
	TTabItem *tbiSignin;
	TLayout *lyPanelLogin;
	TEdit *txtusername;
	TEdit *txtpassword;
	TButton *btnstartsession;
	TLabel *btnsignin;
	TLayout *lySiginPanel;
	TEdit *txtusername_s;
	TEdit *txtemail_s;
	TEdit *txtpassword_s;
	TEdit *txtpassconfirm_s;
	TButton *btnsignin_s;
	TLabel *btnstartsession_s;
	TLayout *Layout1;
	TEdit *txtfn_s;
	TEdit *txtln_s;
	TLayout *lyLeft;
	TLayout *lyRight;
	TOpenDialog *odLoadPhoto;
	TLayout *lyLoading;
	TCircle *crtProfilePhoto;
	void __fastcall btnsigninClick(TObject *Sender);
	void __fastcall btnstartsession_sClick(TObject *Sender);
	void __fastcall btnstartsessionClick(TObject *Sender);
	void __fastcall btnsignin_sClick(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall FormDestroy(TObject *Sender);
	void __fastcall crtProfilePhotoClick(TObject *Sender);
private:	// User declarations
    TForm *NotRequire;

public:		// User declarations
	__fastcall TfrmLogin(TComponent* Owner);

	// closure
    void __fastcall Loading(bool interruptor);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmLogin *frmLogin;
//---------------------------------------------------------------------------
#endif

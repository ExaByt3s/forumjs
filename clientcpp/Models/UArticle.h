//---------------------------------------------------------------------------

#ifndef UArticleH
#define UArticleH

#include <System.Classes.hpp>
#include <FMX.Graphics.hpp>
#include <System.SysUtils.hpp>

#include "UEntityBase.h"

#include <memory>
//---------------------------------------------------------------------------

using refStr = const String&;

class Article : public EntityBase
{
public:
	Article();
	Article(Article&&);
	Article(std::unique_ptr<TBitmap>&& img, int id, int range, refStr title,
			refStr desc, TDateTime create_at);
	~Article();

	Article& operator=(Article&&);

	__property String Title = { read=_title, write=_title };
	__property String Description = { read=_desc, write=_desc };
    __property TDateTime CreateAt = { read=_createat, write=_createat };

private:
	String _title;
	String _desc;
    TDateTime _createat;
};

#endif

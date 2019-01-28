//---------------------------------------------------------------------------

#pragma hdrstop

#include "UArticle.h"
#include "../Controllers/UUtilities.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

Article::Article()
	: EntityBase()
	, _title("")
	, _desc("")
    , _createat()
{
}

Article::Article(Article&& art)
    : EntityBase()
	, _title("")
	, _desc("")
	, _createat()
{
    *this = std::move(art);
}

Article::Article(TBitmap *img, int id, int range, refStr title,
					refStr desc, TDateTime create_at)
	: EntityBase(id, range, img)
	, _title(title)
	, _desc(desc)
    , _createat(create_at)
{
}

Article::~Article()
{
}

Article& Article::operator=(Article&& other)
{
	this->~Article();
	Id = other.Id;
	Range = other.Range;
	MemCopy<TBitmap>(Image, other.Image);
	Title = other.Title;
	Description = other.Description;
	CreateAt = other.CreateAt;
	return *this;
}


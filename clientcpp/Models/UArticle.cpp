//---------------------------------------------------------------------------

#pragma hdrstop

#include "UArticle.h"
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

Article::Article(std::unique_ptr<TBitmap>&& img, int id, int range, refStr title,
					refStr desc, TDateTime create_at)
	: EntityBase(id, range, std::move(img))
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
	SetImage(std::move(other.GetPtrImage()));
	Title = other.Title;
	Description = other.Description;
	CreateAt = other.CreateAt;
	return *this;
}


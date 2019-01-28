//---------------------------------------------------------------------------

#pragma hdrstop

#include "UEntityBase.h"
#include "../Controllers/UUtilities.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

EntityBase::EntityBase()
	: Id(0)
	, Range(0)
	, Image(nullptr)
{
}

EntityBase::EntityBase(EntityBase&& other)
	: Id(0)
	, Range(0)
    , Image(nullptr)
{
    *this = std::move(other);
}

EntityBase::EntityBase(int id, int range, TBitmap* img)
{
	Id = id;
	Range = range;
	MemCopy<TBitmap>(Image, img);
}

EntityBase::~EntityBase()
{
	if (_image) {
		_image->DisposeOf();
        _image = nullptr;
	}
}

EntityBase& EntityBase::operator=(EntityBase&& other)
{
	this->~EntityBase();
	Id = other.Id;
	Range = other.Range;
    MemCopy<TBitmap>(Image, other.Image);
	return *this;
}

void __fastcall EntityBase::PutImage(TBitmap *img)
{
	MemCopy<TBitmap>(Image, img);
}


//---------------------------------------------------------------------------

#pragma hdrstop

#include "UEntityBase.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

EntityBase::EntityBase()
	: Id(0)
	, Range(0)
{
    _image.reset(nullptr);
}

EntityBase::EntityBase(EntityBase&& other)
	: Id(0)
	, Range(0)
{
    *this = std::move(other);
}

EntityBase::EntityBase(int id, int range, std::unique_ptr<TBitmap>&& img)
{
	Id = id;
	Range = range;
	_image.reset(img.release());
}

EntityBase::~EntityBase()
{
    _image.reset(nullptr);
}

EntityBase& EntityBase::operator=(EntityBase&& other)
{
	this->~EntityBase();
	Id = other.Id;
	Range = other.Range;
	_image.reset(other.ReleaseImage());
	return *this;
}

void EntityBase::SetImage(std::unique_ptr<TBitmap>&& other)
{
	_image.reset(other.release());
}

TBitmap* EntityBase::GetImage()
{
	return _image.get();
}

std::unique_ptr<TBitmap>& EntityBase::GetPtrImage()
{
    return _image;
}

TBitmap* EntityBase::ReleaseImage()
{
	return _image.release();
}


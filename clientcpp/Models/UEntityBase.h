//---------------------------------------------------------------------------

#ifndef UEntityBaseH
#define UEntityBaseH

#include <System.Classes.hpp>
#include <FMX.Graphics.hpp>

#include <memory>
//---------------------------------------------------------------------------

class EntityBase
{
public:
	EntityBase();
	EntityBase(EntityBase&&);
	EntityBase(int id, int range, TBitmap *img);
	virtual ~EntityBase();

	EntityBase& operator=(EntityBase&&);

    void __fastcall PutImage(TBitmap *img);

	__property int Id = { read=_id, write=_id };
	__property int Range = { read=_range, write=_range };
    __property TBitmap* Image = { read=_image, write=_image };

private:
	int _id;
    int _range;
	TBitmap *_image;
};

#endif

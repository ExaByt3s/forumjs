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
	EntityBase(int id, int range, std::unique_ptr<TBitmap>&& img);
	virtual ~EntityBase();

    EntityBase& operator=(EntityBase&&);

	void SetImage(std::unique_ptr<TBitmap>&& other);
	TBitmap* GetImage();
    std::unique_ptr<TBitmap>& GetPtrImage();
    TBitmap* ReleaseImage();

	__property int Id = { read=_id, write=_id };
	__property int Range = { read=_range, write=_range };

private:
	int _id;
    int _range;
	std::unique_ptr<TBitmap> _image;
};

#endif

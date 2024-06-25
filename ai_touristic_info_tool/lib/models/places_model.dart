class PlacesModel {
  String name;
  String address;
  String? city;
  String? country;
  String? description;
  double? ratings;
  String? amenities;
  String? price;
  double latitude; 
  double longitude;

  PlacesModel({
    required this.name,
    required this.address,
    this.city,
    this.country,
    this.description,
    this.ratings,
    this.amenities,
    this.price,
    required this.latitude,
    required this.longitude,
  });
}



/*

class Place(BaseModel):
    name: str = Field(description="Full name of the place", default=None)
    address: str = Field(description="Address of the place", default=None)
    city: str = Field(description="Name of the city", default=None)
    country: str = Field(description="Name of the country", default=None)
    description: str = Field(description="A brief description", default=None)
    ratings: float = Field(description="Average rating", default=None) 
    amenities: str = Field(description="Amenities available", default=None)
    price: str = Field(description="Pricing info", default=None) 

class Places(BaseModel):
    places: List[Place] = Field(description="List of Place dictionaries", default=None)

*/
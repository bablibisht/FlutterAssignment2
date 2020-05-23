class Contact{
  int id;
  String name;
  String mobile;
  String landline;
  String image;
  int isFav;

  Contact({this.id, this.name, this.mobile, this.landline, this.image, this.isFav = 0});

  //when retrieving from database
  factory Contact.fromJson(Map<String, dynamic> data){
    return Contact(
      id: data['id'],
      name: data['name'],
      mobile: data['mobile'],
      landline: data['landline'],
      image: data['image'],
      isFav: data['isFav']
    );
  }

  //when storing into database
  Map<String, dynamic> toJson() => {
    "id": this.id,
    "name": this.name,
    "mobile": this.mobile,
    "landline": this.landline,
    "image": this.image,
    "isFav": this.isFav
  };
}
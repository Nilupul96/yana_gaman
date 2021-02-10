class Post {
  String id;
  String title;
  String description;
  List<dynamic> images;
  double long;
  double lat;
  double rating;
  String name;
  String userId;

  Post(
      {this.id,
      this.description,
      this.images,
      this.title,
      this.name,
      this.lat,
      this.rating,
      this.userId,
      this.long});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json["id"]);
  }
}

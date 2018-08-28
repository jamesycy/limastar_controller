class Trip {
  String id;
  bool active;
  String createdAt;
  int helpers;
  String title;

  Trip.fromJson(Map<String, dynamic> json, String tripid) :
    id = tripid,
    active = json['active'],
    createdAt = json['created_at'],
    helpers = json['helpers'],
    title = json['title'];

  Map<String, dynamic> toJson() => {
    "active": this.active,
    "created_at": this.createdAt,
    "helpers": this.helpers,
    "title": this.title
  };

}
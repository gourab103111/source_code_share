class UserInstructorModel {
  int? id;
  String? username;
  String? name;
  String? email;
  String? nickname;
  String? slug;
  String? avatar_url;
  dynamic instructor_data;
  dynamic social;
  String? description;

  UserInstructorModel({
    this.id,
    this.username,
    this.name,
    this.email,
    this.nickname,
    this.slug,
    this.avatar_url,
    this.instructor_data,
    this.social,
    this.description,
  });

  UserInstructorModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    username = json['username'].toString();
    name = json['name'];
    email = json['email'].toString();
    nickname = json['nickname'].toString();
    slug = json['slug'].toString();
    avatar_url = json['avatar_url'].toString();
    description = json['description'].toString();
    if (json['instructor_data'] != null)
      instructor_data = json['instructor_data'];

    if (json['social'] != null) social = json['social'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['nickname'] = nickname;
    data['slug'] = slug;
    data['avatar_url'] = avatar_url;
    data['instructor_data'] = instructor_data;
    data['social'] = social;
    return data;
  }
}

class CategoryModel {
  int? id;
  String? name;
  String? slug;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if(json['id'] != null){
      id = (json['id'] != null) ? json['id'] : 0;
    }else{
      id = (json['term_id'] != null) ? json['term_id'] : 0;
    }

    name = json['name'].toString();
    slug = json['slug'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;

    return data;
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, slug: $slug}';
  }
}

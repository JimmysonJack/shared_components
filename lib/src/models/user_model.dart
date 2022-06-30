class User {
  String email;
  String? name;
  String? phone;
  List<TileFields>? tiles;
  User({required this.email, required this.name, this.phone, this.tiles});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      tiles: (json['tiles'] as List<dynamic>?)
          ?.map((e) => TileFields.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      'tiles': tiles,
    };
  }
}

class TileFields {
  String icon;
  String title;
  String url;
  TileFields({required this.icon, required this.title, required this.url});
  factory TileFields.fromJson(Map<String, dynamic> json) {
    return TileFields(
      icon: json['icon'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'icon': icon,
      'title': title,
      'url': url,
    };
  }
}

class UserModel {
  final String email;
  final String password;
  final String name;
  final String postiton;
  final String? image;

  UserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.postiton,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      postiton: json['postiton'],
      image:
          json['image'] ??
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'postiton': postiton,
      'image': image,
    };
  }
}

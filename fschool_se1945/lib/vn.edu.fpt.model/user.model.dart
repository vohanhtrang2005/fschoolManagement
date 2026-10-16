class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
  });

  // Factory method: Dùng để parse cục JSON từ Backend (Java) trả về thành Object trong Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      email: json['email'],
      password: json['password'],
      name: json['name'],
    );
  }

  // Method: Dùng để chuyển Object trong Dart thành cục JSON gửi lên Backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
    };
  }
}

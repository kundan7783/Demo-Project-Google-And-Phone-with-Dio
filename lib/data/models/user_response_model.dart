class UserResponseModel {
  final bool profileExists; // ✅ non-nullable
  final String? name;
  final String? email;
  final String? message;

  UserResponseModel({
    required this.profileExists,
    this.name,
    this.email,
    this.message,
  });

  factory UserResponseModel.formJson(Map<String, dynamic> json) {
    return UserResponseModel(
      profileExists: json['profileExists'] ?? false,
      name: json['name'],
      email: json['email'],
      message: json['message'],
    );
  }
}

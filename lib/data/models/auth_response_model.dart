class AuthResponseModel {
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final String? status;
  final bool? profileExists;

  AuthResponseModel({
    this.message,
    this.accessToken,
    this.refreshToken,
    this.status,
    this.profileExists,
  });
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      status: json['status'],
      profileExists: json['profileExists'] ?? false
    );
  }
}

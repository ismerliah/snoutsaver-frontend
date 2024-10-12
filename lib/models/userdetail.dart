class UserDetail {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String provider;

  const UserDetail({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.profilePicture,
    required this.provider,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?, // Nullable
      lastName: json['last_name'] as String?,  // Nullable
      profilePicture: json['profile_picture'] as String?,  // Nullable
      provider: json['provider'] as String,
    );
  }
}

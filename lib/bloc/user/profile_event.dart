sealed class ProfileEvent {}

class FetchUserDetailEvent extends ProfileEvent {
  // final int user_id;
  // final String username;
  // final String email;
  // final String first_name;
  // final String last_name;
  // final String profile_picture;
  // final String provider;

  // FetchUserDetailEvent(this.user_id, this.username, this.email, this.first_name, this.last_name, this.profile_picture, this.provider);
}

class UpdateUserDetailEvent extends ProfileEvent {
  final String email;
  final String username;
  final String first_name;
  final String last_name;
  final String profile_picture;

  UpdateUserDetailEvent({
    required this.email,
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.profile_picture,
  });
}

class UpdateProfilePictureEvent extends ProfileEvent {
  final String profile_picture;

  UpdateProfilePictureEvent({
    required this.profile_picture,
  });
}

class ChangePasswordEvent extends ProfileEvent {
  final String current_password;
  final String new_password;

  ChangePasswordEvent(this.current_password, this.new_password);
}
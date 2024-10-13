sealed class ProfileEvent {}

class FetchUserDetailEvent extends ProfileEvent {}

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

  ChangePasswordEvent({ 
    required this.current_password, 
    required this.new_password,
  });
}
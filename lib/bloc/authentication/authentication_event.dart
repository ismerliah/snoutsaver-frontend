sealed class AuthenticationEvent {}

class ResetAuthStateEvent extends AuthenticationEvent {}

class SignupEvent extends AuthenticationEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  SignupEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class SigninEvent extends AuthenticationEvent {
  final String username;
  final String password;

  SigninEvent({
    required this.username,
    required this.password,
  });
}

class SignOutEvent extends AuthenticationEvent {}

class SigninwithGoogleEvent extends AuthenticationEvent {}

class SignoutWithGoogle extends AuthenticationEvent {}
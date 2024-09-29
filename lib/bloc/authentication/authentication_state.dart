sealed class AuthenticationState {}

class AuthInitial extends AuthenticationState {}

// Signup
class SignupSuccess extends AuthenticationState {}

class SignupLoading extends AuthenticationState {}

class SignupFailure extends AuthenticationState {
  final String error;

  SignupFailure({required this.error});

  @override
  String toString() => error;
}

// Signin
class SigninSuccess extends AuthenticationState {}

class SigninLoading extends AuthenticationState {} 

class SigninFailure extends AuthenticationState {
  final String error;

  SigninFailure({required this.error});

  List<Object> get props => [error];
}

// Google Signin
class SigninwithGoogleSuccess extends AuthenticationState {}

class SigninwithGoogleLoading extends AuthenticationState {} 

class SigninwithGoogleFailure extends AuthenticationState {
  final String error;

  SigninwithGoogleFailure({required this.error});

  List<Object> get props => [error];
}

// Signout
class SignoutFailure extends AuthenticationState {
  final String error;

  SignoutFailure({required this.error});

  List<Object> get props => [error];
}
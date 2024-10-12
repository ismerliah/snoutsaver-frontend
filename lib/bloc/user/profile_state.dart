sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class FetchProfileLoading extends ProfileState {}

class FetchProfileSuccess extends ProfileState {}

class FetchProfileFailure extends ProfileState {
  final String error;

  FetchProfileFailure({required this.error});

  @override
  String toString() => error;
}

//update 

class UpdateUserLoading extends ProfileState {}

class UpdateUserSuccess extends ProfileState {}

class UpdateUserFailure extends ProfileState {
  final String error;

  UpdateUserFailure({required this.error});

  @override
  String toString() => error;
}

//update profile

class UpdatePictureLoading extends ProfileState {}class UpdatePictureSuccess extends ProfileState {}

class UpdatePictureFailure extends ProfileState {
  final String error;

  UpdatePictureFailure({required this.error});

  @override
  String toString() => error;
}

// change password
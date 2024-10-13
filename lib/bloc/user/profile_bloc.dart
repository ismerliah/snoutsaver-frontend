import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snoutsaver/bloc/user/profile_event.dart';
import 'package:snoutsaver/bloc/user/profile_state.dart';
import 'package:snoutsaver/repository/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchUserDetailEvent>(_onFetchUserDetail);
    on<UpdateUserDetailEvent>(_onUpdateUserDetail);
    on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onFetchUserDetail(FetchUserDetailEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(FetchProfileLoading());
      await UserRepository().fetchUserDetails();
      emit(FetchProfileSuccess());
    } catch (e) {
      emit(FetchProfileFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateUserDetail(UpdateUserDetailEvent event, Emitter<ProfileState> emit) async {
    try {
      await UserRepository().updateUserDetail(
        email: event.email,
        username: event.username,
        firstName: event.first_name,
        lastName: event.last_name,
        profilePicture: event.profile_picture
      );
      emit(UpdateUserLoading());
      emit(UpdateUserSuccess());
    } catch (e) {
      emit(UpdateUserFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateProfilePicture(UpdateProfilePictureEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdatePictureLoading());

      await UserRepository().updateProfilePicture(
        profilePicture: event.profile_picture
      );
      
      emit(UpdatePictureSuccess());
    } catch (e) {
      emit(UpdatePictureFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ChangePasswordLoading());
      await UserRepository().updatePassword(
        currentPassword: event.current_password, 
        newPassword: event.new_password,
      );
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snoutsaver/bloc/user/profile_event.dart';
import 'package:snoutsaver/bloc/user/profile_state.dart';
import 'package:snoutsaver/repository/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchUserDetailEvent>(_onFetchUserDetail);
    on<UpdateUserDetailEvent>(_onUpdateUserDetail);
    on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
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
        first_name: event.first_name,
        last_name: event.last_name,
        profile_picture: event.profile_picture
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

      final user = await UserRepository().fetchUserDetails();

      await UserRepository().updateUserDetail(
        email: user.email,
        username: user.username,
        first_name: user.firstName,
        last_name: user.lastName,
        profile_picture: event.profile_picture
      );
      
      emit(UpdatePictureSuccess());
    } catch (e) {
      emit(UpdatePictureFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

}
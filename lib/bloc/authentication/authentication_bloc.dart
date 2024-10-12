import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snoutsaver/repository/user_repository.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc() : super(AuthInitial()) {
    on<SignupEvent>(_onSignup);
    on<SigninEvent>(_onSignin);
    on<SignOutEvent>(_onSignout);
    on<SigninwithGoogleEvent>(_onSigninwithGoogle);
    // on<SignoutWithGoogle>(_onSignoutWithGoogle);
  }

  final storage = const FlutterSecureStorage();

  Future<void> _onSignup(SignupEvent event, Emitter<AuthenticationState> emit) async {
    try {
      // emit(SignupLoading());
      await UserRepository().createUser(
        username: event.username,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      emit(SignupLoading());
      emit(SignupSuccess());
    } catch(e) {
      emit(SignupFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignin(SigninEvent event, Emitter<AuthenticationState> emit) async {
    try {
      // emit(SignupLoading());
      await UserRepository().signinUser(
        username: event.username, 
        password: event.password,
      );
      
      String? storedToken = await storage.read(key: "token");
        if (storedToken != null) {
          emit(SigninLoading());
          emit(SigninSuccess());
        } 
    } catch(e) {
      emit(SigninFailure(error: e.toString()));
    }
  }

  Future<void> _onSigninwithGoogle(SigninwithGoogleEvent event, Emitter<AuthenticationState> emit) async {
    try {
      final googleAccount = await GoogleSignIn().signIn();
      if (googleAccount == null) {
        throw Exception("Google sign-in was canceled or failed");
      }
      final googleAuth = await googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
  
      if (firebaseUser != null) {
        emit(SigninwithGoogleLoading());
        await UserRepository().createUserwithGoogle(
          username: firebaseUser.displayName!,
          email: firebaseUser.email!,
          password: firebaseUser.uid,
          confirmPassword: firebaseUser.uid,
        );
        
        // Sign in user
        await UserRepository().signinUser(
          username: firebaseUser.displayName!, 
          password: firebaseUser.uid,
        );

        String? storedToken = await storage.read(key: "token");
        if (storedToken != null) {
          emit(SigninwithGoogleSuccess());
        } 
      }
    } catch (e) {
      emit(SigninwithGoogleFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignout(SignOutEvent event, Emitter<AuthenticationState> emit) async {
    try {
      FirebaseAuth.instance.signOut();
      GoogleSignIn().signOut();
      if (await storage.read(key: "token") != null) {
        await storage.delete(key: "token");
      } else {
        throw Exception("No access token found");
      }
    } catch(e) {
      emit(SignupFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
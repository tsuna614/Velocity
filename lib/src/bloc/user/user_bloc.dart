import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/api/user_api.dart';
import 'package:velocity_app/src/auth/auth_service.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthService _authService = AuthService();
  final UserApi userApi = UserApi();

  UserBloc() : super(UserInitial()) {
    // this should be called first
    // on<checkAuthState>((event, emit) async {
    //   // final isSignedIn = await userApi.isUserSignedIn();
    //   // if (isSignedIn) {
    //   //   add(FetchUser());
    //   // } else {
    //   //   emit(UserInitial());
    //   // }
    //   if (userId.isEmpty) {
    //     // User is not signed in (no userId in local database)
    //     emit(UserInitial());
    //   } else {
    //     add(FetchUser());
    //   }
    // });

    on<FetchUser>((event, emit) async {
      // Call the API to fetch the user
      emit(UserLoading()); // call this to enter loading screen
      final userId = await _authService.getUserId();
      if (userId.isEmpty) {
        emit(UserInitial());
      } else {
        try {
          final MyUser user = await userApi.fetchUserData(userId: userId);
          emit(UserLoaded(user: user));
        } on DioException catch (e) {
          emit(UserFailure(message: e.message!));
        }
      }
    });

    on<SignUp>((event, emit) async {
      // Call the API to sign up the user
      try {
        // sign up, and if success THEN sign in
        await userApi.signUp(user: event.user, password: event.password);
        add(SignIn(email: event.user.email, password: event.password));
      } on DioException catch (e) {
        emit(UserFailure(message: e.message!));
      }
    });

    on<SignIn>((event, emit) async {
      // Call the API to sign in the user
      try {
        final MyUser user =
            await userApi.login(email: event.email, password: event.password);
        emit(UserLoaded(user: user));
      } on DioException catch (e) {
        emit(UserFailure(message: e.message!));
      }
    });

    on<SignOut>((event, emit) async {
      // Call the API to sign out the user
      try {
        // await _firebase.signOut();
        await _authService.clearUserToken();
        emit(UserInitial());
      } on FirebaseAuthException catch (e) {
        emit(UserFailure(message: e.message!));
      }
    });

    on<UpdateUser>((event, emit) {
      // Call the API to update the user
      MyUser updatedUser = event.user;
      emit(UserLoaded(user: updatedUser));
    });

    on<AddBookmark>((event, emit) {
      // Call the API to add a bookmark
      if (state is UserLoaded) {
        MyUser user = (state as UserLoaded).user.copyWith(
          bookmarkedTravels: [
            ...((state as UserLoaded).user.bookmarkedTravels),
            event.travelId
          ],
        );
        emit(UserLoaded(user: user));
      }
    });

    on<RemoveBookmark>((event, emit) {
      // Call the API to remove a bookmark
      if (state is UserLoaded) {
        MyUser user = (state as UserLoaded).user.copyWith(
          bookmarkedTravels: [
            ...((state as UserLoaded).user.bookmarkedTravels)
              ..remove(event.travelId)
          ],
        );
        emit(UserLoaded(user: user));
      }
    });
  }
}

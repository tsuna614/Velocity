import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/services/user_api.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/user_model.dart';
// import 'package:velocity_app/src/data/global_data.dart' as global_data;

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApi userApi;

  UserBloc(this.userApi) : super(UserInitial()) {
    on<FetchUser>((event, emit) async {
      // Call the API to fetch the user
      emit(UserLoading()); // call this to enter loading screen
      final userId = await HiveService.getUserId();
      if (userId.isEmpty) {
        emit(UserInitial());
      } else {
        try {
          final MyUser user = await userApi.fetchUserDataById(userId: userId);
          GlobalData.userId = userId; // set the global user id for easy access
          emit(UserLoaded(user: user));
        } on DioException catch (e) {
          emit(UserFailure(message: e.response!.data!));
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
        emit(UserFailure(message: e.response!.data!));
      }
    });

    on<SignIn>((event, emit) async {
      // Call the API to sign in the user
      try {
        await userApi.login(email: event.email, password: event.password);
        add(FetchUser());
      } on DioException catch (e) {
        emit(UserFailure(message: e.response!.data!));
      }
    });

    on<SignOut>((event, emit) async {
      // Call the API to sign out the user
      try {
        await HiveService.clearUserToken();
        GlobalData.userId = '';
        emit(UserInitial());
      } on DioException catch (e) {
        emit(UserFailure(message: e.response!.statusMessage!));
      }
    });

    on<UpdateUser>((event, emit) async {
      // Call the API to update the user
      try {
        MyUser updatedUser = event.user;
        await userApi.updateUserData(user: updatedUser);
        emit(UserLoaded(user: updatedUser));
      } on DioException {
        // don't emit UserFailure here, because we don't want to log out the user
      }
    });

    on<ToggleBookmark>((event, emit) async {
      // Call the API to add a bookmark
      if (state is UserLoaded) {
        // doesn't await here because we don't need to wait for the response
        userApi.toggleBookmark(
          travelId: event.travelId,
        );
        MyUser user;
        if (!(state as UserLoaded)
            .user
            .bookmarkedTravels
            .contains(event.travelId)) {
          // Bookmark isn't added yet. Add it
          user = (state as UserLoaded).user.copyWith(
            bookmarkedTravels: [
              ...((state as UserLoaded).user.bookmarkedTravels),
              event.travelId
            ],
          );
          // show snackbar
          ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(
              content: Text('Bookmark added'),
              duration: Duration(seconds: 1),
            ),
          );
        } else {
          // Bookmark is already added. Remove it
          user = (state as UserLoaded).user.copyWith(
            bookmarkedTravels: [
              ...((state as UserLoaded).user.bookmarkedTravels)
                ..remove(event.travelId)
            ],
          );
          // show snackbar
          ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(
              content: Text('Bookmark removed'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        emit(UserLoaded(user: user));
      }
    });

    on<AddFriend>((event, emit) async {
      MyUser user = (state as UserLoaded).user.copyWith(
            friends: (state as UserLoaded).user.friends..add(event.friendId),
          );
      emit(UserLoaded(user: user));
    });

    on<RemoveFriend>((event, emit) async {
      try {
        await userApi.removeFriend(friendId: event.friendId);
        if (state is UserLoaded) {
          MyUser user = (state as UserLoaded).user.copyWith(
                friends: (state as UserLoaded).user.friends
                  ..removeWhere((friend) => friend == event.friendId),
              );
          emit(UserLoaded(user: user));
        }
      } on DioException {
        // don't emit UserFailure here, because we don't want to log out the user
      }
    });
  }
}

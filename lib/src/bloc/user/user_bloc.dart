import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/api/user_api.dart';
import 'package:velocity_app/src/hive/hive_service.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/user_model.dart';
import 'package:velocity_app/src/data/global_data.dart' as global_data;

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<FetchUser>((event, emit) async {
      // Call the API to fetch the user
      emit(UserLoading()); // call this to enter loading screen
      final userId = await HiveService.getUserId();
      if (userId.isEmpty) {
        emit(UserInitial());
      } else {
        try {
          final MyUser user = await UserApi.fetchUserDataById(userId: userId);
          global_data.userId = userId; // set the global user id for easy access
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
        await UserApi.signUp(user: event.user, password: event.password);
        add(SignIn(email: event.user.email, password: event.password));
      } on DioException catch (e) {
        emit(UserFailure(message: e.response!.data!));
      }
    });

    on<SignIn>((event, emit) async {
      // Call the API to sign in the user
      try {
        final MyUser user =
            await UserApi.login(email: event.email, password: event.password);
        emit(UserLoaded(user: user));
      } on DioException catch (e) {
        emit(UserFailure(message: e.response!.data!));
      }
    });

    on<SignOut>((event, emit) async {
      // Call the API to sign out the user
      try {
        await HiveService.clearUserToken();
        emit(UserInitial());
      } on DioException catch (e) {
        emit(UserFailure(message: e.response!.statusMessage!));
      }
    });

    on<UpdateUser>((event, emit) async {
      // Call the API to update the user
      try {
        MyUser updatedUser = event.user;
        await UserApi.updateUserData(user: updatedUser);
        emit(UserLoaded(user: updatedUser));
      } on DioException {
        // don't emit UserFailure here, because we don't want to log out the user
      }
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

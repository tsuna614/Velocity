import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/user/user_events.dart';
import 'package:velocity_app/src/bloc/user/user_states.dart';
import 'package:velocity_app/src/model/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _firebase = FirebaseAuth.instance;

  UserBloc() : super(UserInitial()) {
    on<FetchUser>((event, emit) {
      print("objectaasgasdgsdag");
      // Call the API to fetch the user
      final user = MyUser(
          userId: "123456",
          name: "Test User",
          email: "testuser@gmail.com",
          phone: "1234567890");

      emit(UserLoaded(user: user));
    });

    on<SignUp>((event, emit) async {
      // Call the API to sign up the user
      try {
        await _firebase.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(UserSuccess(message: 'User created successfully'));
      } on FirebaseAuthException catch (e) {
        emit(UserFailure(message: e.message!));
      }
    });

    on<SignIn>((event, emit) async {
      // Call the API to sign in the user
      try {
        await _firebase.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(UserSuccess(message: 'User signed in successfully'));
      } on FirebaseAuthException catch (e) {
        emit(UserFailure(message: e.message!));
      }
    });

    on<SignOut>((event, emit) async {
      // Call the API to sign out the user
      try {
        await _firebase.signOut();
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

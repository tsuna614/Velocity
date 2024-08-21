import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/bloc/events.dart';
import 'package:velocity_app/src/bloc/states.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _firebase = FirebaseAuth.instance;

  UserBloc() : super(UserInitial()) {
    on<FetchUser>((event, emit) {
      // Call the API to fetch the user
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
  }

  // UserBloc() : super(UserInitial());

  // @override
  // Stream<UserState> mapEventToState(UserEvent event) async* {
  //   if (event is FetchUser) {
  //     // Call the API to fetch the user
  //   } else if (event is SignUp) {
  //     // Call the API to sign up the user
  //     await _firebase.createUserWithEmailAndPassword(
  //         email: event.email, password: event.password);
  //   } else if (event is SignIn) {
  //     // Call the API to sign in the user
  //     await _firebase.signInWithEmailAndPassword(
  //         email: event.email, password: event.password);
  //   } else if (event is SignOut) {
  //     // Call the API to sign out the user
  //     await _firebase.signOut();
  //   }
  // }
}

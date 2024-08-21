import 'package:velocity_app/src/model/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserSuccess extends UserState {
  final String message;

  UserSuccess({required this.message});
}

class UserFailure extends UserState {
  final String message;

  UserFailure({required this.message});
}

class UserLoaded extends UserState {
  final User user;

  UserLoaded({required this.user});
}

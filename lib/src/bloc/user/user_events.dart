import 'package:flutter/material.dart';
import 'package:velocity_app/src/model/user_model.dart';

abstract class UserEvent {}

class FetchUser extends UserEvent {}

class SignUp extends UserEvent {
  final MyUser user;
  final String password;

  SignUp({
    required this.user,
    required this.password,
  });
}

class SignIn extends UserEvent {
  final String email;
  final String password;

  SignIn({
    required this.email,
    required this.password,
  });
}

class SignOut extends UserEvent {}

class UpdateUser extends UserEvent {
  final MyUser user;

  UpdateUser({
    required this.user,
  });
}

class ToggleBookmark extends UserEvent {
  final String travelId;
  final BuildContext context;

  ToggleBookmark({
    required this.travelId,
    required this.context,
  });
}

class AddFriend extends UserEvent {
  final String friendId;

  AddFriend({
    required this.friendId,
  });
}

class RemoveFriend extends UserEvent {
  final String friendId;

  RemoveFriend({
    required this.friendId,
  });
}

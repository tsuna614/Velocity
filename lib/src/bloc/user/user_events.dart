import 'package:velocity_app/src/model/user_model.dart';

abstract class UserEvent {}

class FetchUser extends UserEvent {
  final String userId;

  FetchUser({required this.userId});
}

class SignUp extends UserEvent {
  final String email;
  final String password;

  SignUp({
    required this.email,
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

class AddBookmark extends UserEvent {
  final String travelId;

  AddBookmark({
    required this.travelId,
  });
}

class RemoveBookmark extends UserEvent {
  final String travelId;

  RemoveBookmark({
    required this.travelId,
  });
}

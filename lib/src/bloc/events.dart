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

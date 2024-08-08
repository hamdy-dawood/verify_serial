abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class NetworkErrorState extends LoginStates {}

class LoginFailedState extends LoginStates {
  final String msg;

  LoginFailedState({required this.msg});
}

class ChanceVisibilityState extends LoginStates {}

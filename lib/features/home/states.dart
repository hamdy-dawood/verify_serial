abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class ProfileLoadingState extends HomeStates {}

class ProfileSuccessState extends HomeStates {}

class NetworkErrorState extends HomeStates {}

class ProfileFailedState extends HomeStates {
  final String msg;

  ProfileFailedState({required this.msg});
}

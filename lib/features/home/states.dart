abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class ProfileLoadingState extends HomeStates {}

class ProfileSuccessState extends HomeStates {}

class NetworkErrorState extends HomeStates {}

class ProfileFailedState extends HomeStates {
  final String msg;

  ProfileFailedState({required this.msg});
}

//=========================== VERIFY SERIAL =======================//

class VerifyLoadingState extends HomeStates {}

class VerifySuccessState extends HomeStates {}

class VerifyNetworkErrorState extends HomeStates {}

class VerifyFailedState extends HomeStates {
  final String msg;

  VerifyFailedState({required this.msg});
}

abstract class VerifyStates {}

class VerifyInitialState extends VerifyStates {}

class VerifyLoadingState extends VerifyStates {}

class VerifySuccessState extends VerifyStates {}

class VerifyNetworkErrorState extends VerifyStates {}

class VerifyFailedState extends VerifyStates {
  final String msg;

  VerifyFailedState({required this.msg});
}

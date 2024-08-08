abstract class CheckStates {}

class CheckInitialState extends CheckStates {}

class CheckLoadingState extends CheckStates {}



class NetworkErrorState extends CheckStates {}

class CheckFailedState extends CheckStates {
  final String msg;

  CheckFailedState({required this.msg});
}

class CheckApprovedState extends CheckStates {}

class CheckFailedApprovedState extends CheckStates {}


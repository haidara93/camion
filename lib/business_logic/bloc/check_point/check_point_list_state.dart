part of 'check_point_list_bloc.dart';

sealed class CheckPointListState extends Equatable {
  const CheckPointListState();

  @override
  List<Object> get props => [];
}

final class CheckPointListInitial extends CheckPointListState {}

class CheckPointListLoadingProgress extends CheckPointListState {}

class CheckPointListLoadedSuccess extends CheckPointListState {
  final List<CheckPathPoint> pathpoints;

  const CheckPointListLoadedSuccess(this.pathpoints);
}

class CheckPointListLoadedFailed extends CheckPointListState {
  final String errortext;

  const CheckPointListLoadedFailed(this.errortext);
}

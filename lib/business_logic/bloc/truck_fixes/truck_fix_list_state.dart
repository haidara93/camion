part of 'truck_fix_list_bloc.dart';

sealed class TruckFixListState extends Equatable {
  const TruckFixListState();

  @override
  List<Object> get props => [];
}

final class TruckFixListInitial extends TruckFixListState {}

class TruckFixListLoadingProgress extends TruckFixListState {}

class TruckFixListLoadedSuccess extends TruckFixListState {
  final List<TruckExpense> fixes;

  const TruckFixListLoadedSuccess(this.fixes);
}

class TruckFixListLoadedFailed extends TruckFixListState {
  final String errorstring;

  TruckFixListLoadedFailed(this.errorstring);
}

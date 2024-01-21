part of 'trucks_list_bloc.dart';

sealed class TrucksListState extends Equatable {
  const TrucksListState();

  @override
  List<Object> get props => [];
}

final class TrucksListInitial extends TrucksListState {}

class TrucksListLoadingProgress extends TrucksListState {}

class TrucksListLoadedSuccess extends TrucksListState {
  final List<Truck> trucks;

  const TrucksListLoadedSuccess(this.trucks);
}

class TrucksListLoadedFailed extends TrucksListState {
  final String errortext;

  const TrucksListLoadedFailed(this.errortext);
}

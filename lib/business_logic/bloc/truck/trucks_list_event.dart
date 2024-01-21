part of 'trucks_list_bloc.dart';

sealed class TrucksListEvent extends Equatable {
  const TrucksListEvent();

  @override
  List<Object> get props => [];
}

class TrucksListLoadEvent extends TrucksListEvent {
  final int truckType;

  TrucksListLoadEvent(this.truckType);
}

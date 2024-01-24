part of 'truck_details_bloc.dart';

sealed class TruckDetailsEvent extends Equatable {
  const TruckDetailsEvent();

  @override
  List<Object> get props => [];
}

class TruckDetailsLoadEvent extends TruckDetailsEvent {
  final int id;

  TruckDetailsLoadEvent(this.id);
}

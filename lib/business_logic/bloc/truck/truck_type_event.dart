part of 'truck_type_bloc.dart';

sealed class TruckTypeEvent extends Equatable {
  const TruckTypeEvent();

  @override
  List<Object> get props => [];
}

class TruckTypeLoadEvent extends TruckTypeEvent {}

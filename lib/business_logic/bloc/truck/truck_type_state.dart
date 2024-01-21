part of 'truck_type_bloc.dart';

sealed class TruckTypeState extends Equatable {
  const TruckTypeState();

  @override
  List<Object> get props => [];
}

final class TruckTypeInitial extends TruckTypeState {}

class TruckTypeLoadingProgress extends TruckTypeState {}

class TruckTypeLoadedSuccess extends TruckTypeState {
  final List<TruckType> truckTypes;

  const TruckTypeLoadedSuccess(this.truckTypes);
}

class TruckTypeLoadedFailed extends TruckTypeState {
  final String errortext;

  const TruckTypeLoadedFailed(this.errortext);
}

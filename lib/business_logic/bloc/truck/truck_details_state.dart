part of 'truck_details_bloc.dart';

sealed class TruckDetailsState extends Equatable {
  const TruckDetailsState();

  @override
  List<Object> get props => [];
}

final class TruckDetailsInitial extends TruckDetailsState {}

class TruckDetailsLoadingProgress extends TruckDetailsState {}

class TruckDetailsLoadedSuccess extends TruckDetailsState {
  final Truck truck;

  const TruckDetailsLoadedSuccess(this.truck);
}

class TruckDetailsLoadedFailed extends TruckDetailsState {
  final String errortext;

  const TruckDetailsLoadedFailed(this.errortext);
}

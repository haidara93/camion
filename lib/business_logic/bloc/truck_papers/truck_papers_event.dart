part of 'truck_papers_bloc.dart';

class TruckPapersEvent extends Equatable {
  const TruckPapersEvent();

  @override
  List<Object> get props => [];
}

class TruckPapersLoad extends TruckPapersEvent {
  final int truckId;

  TruckPapersLoad(this.truckId);
}

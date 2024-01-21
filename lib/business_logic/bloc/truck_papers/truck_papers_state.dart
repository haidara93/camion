part of 'truck_papers_bloc.dart';

class TruckPapersState extends Equatable {
  const TruckPapersState();

  @override
  List<Object> get props => [];
}

class TruckPapersInitial extends TruckPapersState {}

class TruckPapersLoadingProgress extends TruckPapersState {}

class TruckPapersLoadedSuccess extends TruckPapersState {
  final List<TruckPaper> truckPaperss;

  const TruckPapersLoadedSuccess(this.truckPaperss);
}

class TruckPapersLoadedFailed extends TruckPapersState {
  final String errorstring;

  TruckPapersLoadedFailed(this.errorstring);
}

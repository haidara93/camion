part of 'create_truck_paper_bloc.dart';

class CreateTruckPaperState extends Equatable {
  const CreateTruckPaperState();

  @override
  List<Object> get props => [];
}

class CreateTruckPaperInitial extends CreateTruckPaperState {}

class CreateTruckPaperLoadingProgress extends CreateTruckPaperState {}

class CreateTruckPaperLoadedSuccess extends CreateTruckPaperState {
  final TruckPaper paper;

  const CreateTruckPaperLoadedSuccess(this.paper);
}

class CreateTruckPaperLoadedFailed extends CreateTruckPaperState {
  final String errorstring;

  CreateTruckPaperLoadedFailed(this.errorstring);
}

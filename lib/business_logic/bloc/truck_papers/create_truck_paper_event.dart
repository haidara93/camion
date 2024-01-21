part of 'create_truck_paper_bloc.dart';

sealed class CreateTruckPaperEvent extends Equatable {
  const CreateTruckPaperEvent();

  @override
  List<Object> get props => [];
}

class CreateTruckPaperButtonPressed extends CreateTruckPaperEvent {
  final TruckPaper paper;
  final File image;
  CreateTruckPaperButtonPressed(this.paper, this.image);
}

part of 'create_truck_fix_bloc.dart';

sealed class CreateTruckFixEvent extends Equatable {
  const CreateTruckFixEvent();

  @override
  List<Object> get props => [];
}

class CreateTruckFixButtonPressed extends CreateTruckFixEvent {
  final TruckExpense fix;
  CreateTruckFixButtonPressed(this.fix);
}

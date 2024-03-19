part of 'create_pass_charges_bloc.dart';

sealed class CreatePassChargesEvent extends Equatable {
  const CreatePassChargesEvent();

  @override
  List<Object> get props => [];
}

class CreatePassChargesButtonPressedEvent extends CreatePassChargesEvent {
  final PassCharges charges;

  CreatePassChargesButtonPressedEvent({required this.charges});
}

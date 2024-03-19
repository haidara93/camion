part of 'create_pass_charges_bloc.dart';

sealed class CreatePassChargesState extends Equatable {
  const CreatePassChargesState();

  @override
  List<Object> get props => [];
}

final class CreatePassChargesInitial extends CreatePassChargesState {}

class CreatePassChargesLoadingProgress extends CreatePassChargesState {}

class CreatePassChargesLoadedSuccess extends CreatePassChargesState {}

class CreatePassChargesLoadedFailed extends CreatePassChargesState {
  final String error;

  const CreatePassChargesLoadedFailed(this.error);
}

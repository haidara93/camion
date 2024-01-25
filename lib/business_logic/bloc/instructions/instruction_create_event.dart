part of 'instruction_create_bloc.dart';

sealed class InstructionCreateEvent extends Equatable {
  const InstructionCreateEvent();

  @override
  List<Object> get props => [];
}

class InstructionCreateButtonPressed extends InstructionCreateEvent {
  final Shipmentinstruction instruction;

  InstructionCreateButtonPressed(this.instruction);
}

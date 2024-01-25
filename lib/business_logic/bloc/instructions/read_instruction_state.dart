part of 'read_instruction_bloc.dart';

sealed class ReadInstructionState extends Equatable {
  const ReadInstructionState();

  @override
  List<Object> get props => [];
}

final class ReadInstructionInitial extends ReadInstructionState {}

class ReadInstructionLoadingProgress extends ReadInstructionState {}

class ReadInstructionLoadedSuccess extends ReadInstructionState {
  final Shipmentinstruction instruction;

  const ReadInstructionLoadedSuccess(this.instruction);
}

class ReadInstructionLoadedFailed extends ReadInstructionState {
  final String errortext;

  const ReadInstructionLoadedFailed(this.errortext);
}

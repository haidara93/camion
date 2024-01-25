part of 'read_instruction_bloc.dart';

sealed class ReadInstructionEvent extends Equatable {
  const ReadInstructionEvent();

  @override
  List<Object> get props => [];
}

class ReadInstructionLoadEvent extends ReadInstructionEvent {
  final int id;

  ReadInstructionLoadEvent(this.id);
}

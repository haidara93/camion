import 'package:bloc/bloc.dart';
import 'package:camion/data/models/instruction_model.dart';
import 'package:equatable/equatable.dart';

part 'read_instruction_event.dart';
part 'read_instruction_state.dart';

class ReadInstructionBloc
    extends Bloc<ReadInstructionEvent, ReadInstructionState> {
  ReadInstructionBloc() : super(ReadInstructionInitial()) {
    on<ReadInstructionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

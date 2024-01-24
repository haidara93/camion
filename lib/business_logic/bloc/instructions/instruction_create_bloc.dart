import 'package:bloc/bloc.dart';
import 'package:camion/data/models/instruction_model.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'instruction_create_event.dart';
part 'instruction_create_state.dart';

class InstructionCreateBloc
    extends Bloc<InstructionCreateEvent, InstructionCreateState> {
  late ShippmentRerository shippmentRerository;
  InstructionCreateBloc({required this.shippmentRerository})
      : super(InstructionCreateInitial()) {
    on<InstructionCreateButtonPressed>((event, emit) async {
      emit(InstructionLoadingProgressState());
      try {
        var result = await shippmentRerository
            .createShipmentInstruction(event.instruction);

        emit(InstructionCreateSuccessState(result!));
      } catch (e) {
        emit(InstructionCreateFailureState(e.toString()));
      }
    });
  }
}

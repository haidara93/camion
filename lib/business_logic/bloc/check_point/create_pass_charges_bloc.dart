import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_pass_charges_event.dart';
part 'create_pass_charges_state.dart';

class CreatePassChargesBloc
    extends Bloc<CreatePassChargesEvent, CreatePassChargesState> {
  late CheckPointRepository checkPointRepository;
  CreatePassChargesBloc({required this.checkPointRepository})
      : super(CreatePassChargesInitial()) {
    on<CreatePassChargesButtonPressedEvent>((event, emit) async {
      emit(CreatePassChargesLoadingProgress());
      try {
        var result = await checkPointRepository.createCharges(event.charges);
        if (result) {
          emit(CreatePassChargesLoadedSuccess());
        } else {
          emit(const CreatePassChargesLoadedFailed("error"));
        }
      } catch (e) {
        emit(CreatePassChargesLoadedFailed(e.toString()));
      }
    });
  }
}

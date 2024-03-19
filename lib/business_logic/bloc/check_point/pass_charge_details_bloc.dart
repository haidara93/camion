import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'pass_charge_details_event.dart';
part 'pass_charge_details_state.dart';

class PassChargeDetailsBloc
    extends Bloc<PassChargeDetailsEvent, PassChargeDetailsState> {
  late CheckPointRepository checkPointRepository;

  PassChargeDetailsBloc({required this.checkPointRepository})
      : super(PassChargeDetailsInitial()) {
    on<PassChargeDetailsLoadEvent>((event, emit) async {
      emit(PassChargeDetailsLoadingProgress());
      try {
        var checkPoints =
            await checkPointRepository.getPassChargesDetail(event.id);
        emit(PassChargeDetailsLoadedSuccess(checkPoints!));
        // ignore: empty_catches
      } catch (e) {}
    });
  }
}

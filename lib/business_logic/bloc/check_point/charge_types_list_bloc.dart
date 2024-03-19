import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'charge_types_list_event.dart';
part 'charge_types_list_state.dart';

class ChargeTypesListBloc
    extends Bloc<ChargeTypesListEvent, ChargeTypesListState> {
  late CheckPointRepository checkPointRepository;
  ChargeTypesListBloc({required this.checkPointRepository})
      : super(ChargeTypesListInitial()) {
    on<ChargeTypesListLoadEvent>((event, emit) async {
      emit(ChargeTypesListLoadingProgress());
      try {
        var chargeTypes = await checkPointRepository.getChargeTypes();
        emit(ChargeTypesListLoadedSuccess(chargeTypes));
        // ignore: empty_catches
      } catch (e) {}
    });
  }
}

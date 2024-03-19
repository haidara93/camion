import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'passcharges_list_event.dart';
part 'passcharges_list_state.dart';

class PasschargesListBloc
    extends Bloc<PasschargesListEvent, PasschargesListState> {
  late CheckPointRepository checkPointRepository;
  PasschargesListBloc({required this.checkPointRepository})
      : super(PasschargesListInitial()) {
    on<PasschargesListLoadEvent>((event, emit) async {
      emit(PasschargesListLoadingProgress());
      try {
        var result = await checkPointRepository.getPassCharges();
        emit(PasschargesListLoadedSuccess(result));
      } catch (e) {
        emit(PasschargesListLoadedFailed(e.toString()));
      }
    });
  }
}

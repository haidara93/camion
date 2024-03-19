import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'check_point_list_event.dart';
part 'check_point_list_state.dart';

class CheckPointListBloc
    extends Bloc<CheckPointListEvent, CheckPointListState> {
  late CheckPointRepository checkPointRepository;
  CheckPointListBloc({required this.checkPointRepository})
      : super(CheckPointListInitial()) {
    on<CheckPointListLoadEvent>((event, emit) async {
      emit(CheckPointListLoadingProgress());
      try {
        var checkPoints = await checkPointRepository.getCheckPathPoints();
        emit(CheckPointListLoadedSuccess(checkPoints));
        // ignore: empty_catches
      } catch (e) {}
    });
  }
}

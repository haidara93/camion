import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'permission_details_event.dart';
part 'permission_details_state.dart';

class PermissionDetailsBloc
    extends Bloc<PermissionDetailsEvent, PermissionDetailsState> {
  late CheckPointRepository checkPointRepository;
  PermissionDetailsBloc({required this.checkPointRepository})
      : super(PermissionDetailsInitial()) {
    on<PermissionDetailsLoadEvent>((event, emit) async {
      emit(PermissionDetailsLoadingProgress());
      try {
        var checkPoints =
            await checkPointRepository.getPermissionDetail(event.id);
        emit(PermissionDetailsLoadedSuccess(checkPoints!));
        // ignore: empty_catches
      } catch (e) {}
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'permissions_list_event.dart';
part 'permissions_list_state.dart';

class PermissionsListBloc
    extends Bloc<PermissionsListEvent, PermissionsListState> {
  late CheckPointRepository checkPointRepository;
  PermissionsListBloc({required this.checkPointRepository})
      : super(PermissionsListInitial()) {
    on<PermissionsListLoadEvent>((event, emit) async {
      emit(PermissionsListLoadingProgress());
      try {
        var result = await checkPointRepository.getPermissions();
        emit(PermissionsListLoadedSuccess(result));
      } catch (e) {
        emit(PermissionsListLoadedFailed(e.toString()));
      }
    });
  }
}

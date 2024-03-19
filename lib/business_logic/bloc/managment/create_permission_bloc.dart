import 'package:bloc/bloc.dart';
import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/data/repositories/check_point_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_permission_event.dart';
part 'create_permission_state.dart';

class CreatePermissionBloc
    extends Bloc<CreatePermissionEvent, CreatePermissionState> {
  late CheckPointRepository checkPointRepository;
  CreatePermissionBloc({required this.checkPointRepository})
      : super(CreatePermissionInitial()) {
    on<CreatePermissionButtonPressedEvent>((event, emit) async {
      emit(CreatePermissionLoadingProgress());
      try {
        var result =
            await checkPointRepository.createPermission(event.permission);
        if (result) {
          emit(CreatePermissionLoadedSuccess());
        } else {
          emit(const CreatePermissionLoadedFailed("error"));
        }
      } catch (e) {
        emit(CreatePermissionLoadedFailed(e.toString()));
      }
    });
  }
}

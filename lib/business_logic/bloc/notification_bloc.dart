import 'package:bloc/bloc.dart';
import 'package:camion/data/models/notification_model.dart';
import 'package:camion/data/repositories/notification_repository.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  late NotificationRepository notificationRepository;
  NotificationBloc({required this.notificationRepository})
      : super(NotificationInitial()) {
    on<NotificationLoadEvent>((event, emit) async {
      emit(NotificationLoadingProgress());
      try {
        var data = await notificationRepository.getNotification();
        emit(NotificationLoadedSuccess(notifications: data));
      } catch (e) {
        emit(NotificationLoadedFailed(errorText: e.toString()));
      }
    });
  }
}

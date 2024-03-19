part of 'create_permission_bloc.dart';

sealed class CreatePermissionEvent extends Equatable {
  const CreatePermissionEvent();

  @override
  List<Object> get props => [];
}

class CreatePermissionButtonPressedEvent extends CreatePermissionEvent {
  final Permission permission;

  CreatePermissionButtonPressedEvent({required this.permission});
}

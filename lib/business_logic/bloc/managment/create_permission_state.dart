part of 'create_permission_bloc.dart';

sealed class CreatePermissionState extends Equatable {
  const CreatePermissionState();

  @override
  List<Object> get props => [];
}

final class CreatePermissionInitial extends CreatePermissionState {}

class CreatePermissionLoadingProgress extends CreatePermissionState {}

class CreatePermissionLoadedSuccess extends CreatePermissionState {}

class CreatePermissionLoadedFailed extends CreatePermissionState {
  final String error;

  const CreatePermissionLoadedFailed(this.error);
}

part of 'permission_details_bloc.dart';

sealed class PermissionDetailsState extends Equatable {
  const PermissionDetailsState();

  @override
  List<Object> get props => [];
}

final class PermissionDetailsInitial extends PermissionDetailsState {}

class PermissionDetailsLoadingProgress extends PermissionDetailsState {}

class PermissionDetailsLoadedSuccess extends PermissionDetailsState {
  final PermissionDetail premission;

  const PermissionDetailsLoadedSuccess(this.premission);
}

class PermissionDetailsLoadedFailed extends PermissionDetailsState {
  final String errortext;

  const PermissionDetailsLoadedFailed(this.errortext);
}

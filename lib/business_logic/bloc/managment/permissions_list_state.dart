part of 'permissions_list_bloc.dart';

sealed class PermissionsListState extends Equatable {
  const PermissionsListState();

  @override
  List<Object> get props => [];
}

final class PermissionsListInitial extends PermissionsListState {}

class PermissionsListLoadingProgress extends PermissionsListState {}

class PermissionsListLoadedSuccess extends PermissionsListState {
  final List<Permission> permissions;

  const PermissionsListLoadedSuccess(this.permissions);
}

class PermissionsListLoadedFailed extends PermissionsListState {
  final String error;

  const PermissionsListLoadedFailed(this.error);
}

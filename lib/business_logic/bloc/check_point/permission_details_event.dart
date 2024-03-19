part of 'permission_details_bloc.dart';

sealed class PermissionDetailsEvent extends Equatable {
  const PermissionDetailsEvent();

  @override
  List<Object> get props => [];
}

class PermissionDetailsLoadEvent extends PermissionDetailsEvent {
  final int id;

  PermissionDetailsLoadEvent({required this.id});
}

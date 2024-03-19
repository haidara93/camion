part of 'permissions_list_bloc.dart';

sealed class PermissionsListEvent extends Equatable {
  const PermissionsListEvent();

  @override
  List<Object> get props => [];
}

class PermissionsListLoadEvent extends PermissionsListEvent {}

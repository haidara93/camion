part of 'check_point_list_bloc.dart';

sealed class CheckPointListEvent extends Equatable {
  const CheckPointListEvent();

  @override
  List<Object> get props => [];
}

class CheckPointListLoadEvent extends CheckPointListEvent {}

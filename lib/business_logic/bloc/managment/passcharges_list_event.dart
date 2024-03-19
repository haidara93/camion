part of 'passcharges_list_bloc.dart';

sealed class PasschargesListEvent extends Equatable {
  const PasschargesListEvent();

  @override
  List<Object> get props => [];
}

class PasschargesListLoadEvent extends PasschargesListEvent {}

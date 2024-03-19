part of 'charge_types_list_bloc.dart';

sealed class ChargeTypesListEvent extends Equatable {
  const ChargeTypesListEvent();

  @override
  List<Object> get props => [];
}

class ChargeTypesListLoadEvent extends ChargeTypesListEvent {}

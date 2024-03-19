part of 'charge_types_list_bloc.dart';

sealed class ChargeTypesListState extends Equatable {
  const ChargeTypesListState();

  @override
  List<Object> get props => [];
}

final class ChargeTypesListInitial extends ChargeTypesListState {}

class ChargeTypesListLoadingProgress extends ChargeTypesListState {}

class ChargeTypesListLoadedSuccess extends ChargeTypesListState {
  final List<ChargeType> chargeTypes;

  const ChargeTypesListLoadedSuccess(this.chargeTypes);
}

class ChargeTypesListLoadedFailed extends ChargeTypesListState {
  final String errortext;

  const ChargeTypesListLoadedFailed(this.errortext);
}

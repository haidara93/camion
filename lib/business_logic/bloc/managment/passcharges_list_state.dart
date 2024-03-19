part of 'passcharges_list_bloc.dart';

sealed class PasschargesListState extends Equatable {
  const PasschargesListState();
  
  @override
  List<Object> get props => [];
}

final class PasschargesListInitial extends PasschargesListState {}

class PasschargesListLoadingProgress extends PasschargesListState {}

class PasschargesListLoadedSuccess extends PasschargesListState {
  final List<PassCharges> charges;

  const PasschargesListLoadedSuccess(this.charges);
}

class PasschargesListLoadedFailed extends PasschargesListState {
  final String error;

  const PasschargesListLoadedFailed(this.error);
}
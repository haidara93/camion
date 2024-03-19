part of 'pass_charge_details_bloc.dart';

sealed class PassChargeDetailsState extends Equatable {
  const PassChargeDetailsState();

  @override
  List<Object> get props => [];
}

final class PassChargeDetailsInitial extends PassChargeDetailsState {}

class PassChargeDetailsLoadingProgress extends PassChargeDetailsState {}

class PassChargeDetailsLoadedSuccess extends PassChargeDetailsState {
  final PassChargesDetail charge;

  const PassChargeDetailsLoadedSuccess(this.charge);
}

class PassChargeDetailsLoadedFailed extends PassChargeDetailsState {
  final String errortext;

  const PassChargeDetailsLoadedFailed(this.errortext);
}

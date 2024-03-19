part of 'pass_charge_details_bloc.dart';

sealed class PassChargeDetailsEvent extends Equatable {
  const PassChargeDetailsEvent();

  @override
  List<Object> get props => [];
}

class PassChargeDetailsLoadEvent extends PassChargeDetailsEvent {
  final int id;

  PassChargeDetailsLoadEvent({required this.id});
}

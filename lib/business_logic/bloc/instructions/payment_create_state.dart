part of 'payment_create_bloc.dart';

sealed class PaymentCreateState extends Equatable {
  const PaymentCreateState();

  @override
  List<Object> get props => [];
}

final class PaymentCreateInitial extends PaymentCreateState {}

class PaymentLoadingProgressState extends PaymentCreateState {}

class PaymentCreateSuccessState extends PaymentCreateState {
  final int shipment;

  PaymentCreateSuccessState(this.shipment);
}

class PaymentCreateErrorState extends PaymentCreateState {
  final String? error;
  const PaymentCreateErrorState(this.error);
}

class PaymentCreateFailureState extends PaymentCreateState {
  final String errorMessage;

  const PaymentCreateFailureState(this.errorMessage);
}

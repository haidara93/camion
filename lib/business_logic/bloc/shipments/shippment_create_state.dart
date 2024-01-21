part of 'shippment_create_bloc.dart';

sealed class ShippmentCreateState extends Equatable {
  const ShippmentCreateState();

  @override
  List<Object> get props => [];
}

final class ShippmentCreateInitial extends ShippmentCreateState {}

class ShippmentLoadingProgressState extends ShippmentCreateState {}

class ShippmentCreateSuccessState extends ShippmentCreateState {
  final int shipment;

  ShippmentCreateSuccessState(this.shipment);
}

class ShippmentCreateErrorState extends ShippmentCreateState {
  final String? error;
  const ShippmentCreateErrorState(this.error);
}

class ShippmentCreateFailureState extends ShippmentCreateState {
  final String errorMessage;

  const ShippmentCreateFailureState(this.errorMessage);
}

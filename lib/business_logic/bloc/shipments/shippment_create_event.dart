part of 'shippment_create_bloc.dart';

sealed class ShippmentCreateEvent extends Equatable {
  const ShippmentCreateEvent();

  @override
  List<Object> get props => [];
}

class ShippmentCreateButtonPressed extends ShippmentCreateEvent {
  final Shipment shipment;
  final int driver;
  ShippmentCreateButtonPressed(this.shipment, this.driver);
}

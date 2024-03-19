part of 'shipment_multi_create_bloc.dart';

sealed class ShipmentMultiCreateEvent extends Equatable {
  const ShipmentMultiCreateEvent();

  @override
  List<Object> get props => [];
}

class ShipmentMultiCreateButtonPressed extends ShipmentMultiCreateEvent {
  final Shipmentv2 shipment;
  ShipmentMultiCreateButtonPressed(this.shipment);
}

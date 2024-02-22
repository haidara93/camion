part of 'shipment_update_status_bloc.dart';

sealed class ShipmentUpdateStatusEvent extends Equatable {
  const ShipmentUpdateStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateShipmentStatusEvent extends ShipmentUpdateStatusEvent {
  final int shipmentId;
  final String state;

  const UpdateShipmentStatusEvent(this.shipmentId, this.state);
}

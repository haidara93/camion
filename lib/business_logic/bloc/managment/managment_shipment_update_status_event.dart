part of 'managment_shipment_update_status_bloc.dart';

sealed class ManagmentShipmentUpdateStatusEvent extends Equatable {
  const ManagmentShipmentUpdateStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateStatusManagmentShipmentEvent
    extends ManagmentShipmentUpdateStatusEvent {
  final int offerId;
  final String state;

  const UpdateStatusManagmentShipmentEvent(this.offerId, this.state);
}

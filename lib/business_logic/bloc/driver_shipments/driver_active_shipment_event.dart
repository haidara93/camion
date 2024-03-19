part of 'driver_active_shipment_bloc.dart';

sealed class DriverActiveShipmentEvent extends Equatable {
  const DriverActiveShipmentEvent();

  @override
  List<Object> get props => [];
}

class DriverActiveShipmentLoadEvent extends DriverActiveShipmentEvent {
  final String state;

  DriverActiveShipmentLoadEvent(this.state);
}

class DriverActiveShipmentForOwnerLoadEvent extends DriverActiveShipmentEvent {
  final String state;
  final int driver;

  DriverActiveShipmentForOwnerLoadEvent(this.state, this.driver);
}

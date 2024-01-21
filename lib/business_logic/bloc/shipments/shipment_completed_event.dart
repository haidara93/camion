part of 'shipment_completed_bloc.dart';

class ShipmentCompletedEvent extends Equatable {
  const ShipmentCompletedEvent();

  @override
  List<Object> get props => [];
}

class ShipmentCompletedLoadEvent extends ShipmentCompletedEvent {
  final String state;

  ShipmentCompletedLoadEvent(this.state);
}

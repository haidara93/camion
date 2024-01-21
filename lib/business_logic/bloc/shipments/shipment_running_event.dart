part of 'shipment_running_bloc.dart';

class ShipmentRunningEvent extends Equatable {
  const ShipmentRunningEvent();

  @override
  List<Object> get props => [];
}

class ShipmentRunningLoadEvent extends ShipmentRunningEvent {
  final String state;

  ShipmentRunningLoadEvent(this.state);
}

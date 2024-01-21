part of 'shipment_list_bloc.dart';

class ShipmentListEvent extends Equatable {
  const ShipmentListEvent();

  @override
  List<Object> get props => [];
}

class ShipmentListLoadEvent extends ShipmentListEvent {
  final String state;

  ShipmentListLoadEvent(this.state);
}

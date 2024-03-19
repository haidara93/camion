part of 'managment_shipment_list_bloc.dart';

sealed class ManagmentShipmentListEvent extends Equatable {
  const ManagmentShipmentListEvent();

  @override
  List<Object> get props => [];
}

class ManagmentShipmentListLoadEvent extends ManagmentShipmentListEvent {
  final String state;

  ManagmentShipmentListLoadEvent(this.state);
}

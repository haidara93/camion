part of 'complete_managment_shipment_list_bloc.dart';

sealed class CompleteManagmentShipmentListEvent extends Equatable {
  const CompleteManagmentShipmentListEvent();

  @override
  List<Object> get props => [];
}

class CompleteManagmentShipmentListLoadEvent
    extends CompleteManagmentShipmentListEvent {
  final String state;

  CompleteManagmentShipmentListLoadEvent(this.state);
}

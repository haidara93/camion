part of 'unassigned_shipment_list_bloc.dart';

sealed class UnassignedShipmentListEvent extends Equatable {
  const UnassignedShipmentListEvent();

  @override
  List<Object> get props => [];
}

class UnassignedShipmentListLoadEvent extends UnassignedShipmentListEvent {
  UnassignedShipmentListLoadEvent();
}

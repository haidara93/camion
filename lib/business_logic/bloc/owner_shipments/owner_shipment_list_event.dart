part of 'owner_shipment_list_bloc.dart';

sealed class OwnerShipmentListEvent extends Equatable {
  const OwnerShipmentListEvent();

  @override
  List<Object> get props => [];
}

class OwnerShipmentListLoadEvent extends OwnerShipmentListEvent {
  final String state;

  OwnerShipmentListLoadEvent(this.state);
}

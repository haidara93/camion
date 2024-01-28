part of 'shipment_details_bloc.dart';

sealed class ShipmentDetailsEvent extends Equatable {
  const ShipmentDetailsEvent();

  @override
  List<Object> get props => [];
}

class ShipmentDetailsLoadEvent extends ShipmentDetailsEvent {
  final int id;

  ShipmentDetailsLoadEvent(this.id);
}

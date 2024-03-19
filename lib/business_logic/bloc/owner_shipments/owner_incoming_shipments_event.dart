part of 'owner_incoming_shipments_bloc.dart';

class OwnerIncomingShipmentsEvent extends Equatable {
  const OwnerIncomingShipmentsEvent();

  @override
  List<Object> get props => [];
}

class OwnerIncomingShipmentsLoadEvent extends OwnerIncomingShipmentsEvent {
  final String state;
  final int driverId;

  OwnerIncomingShipmentsLoadEvent(this.state, this.driverId);
}

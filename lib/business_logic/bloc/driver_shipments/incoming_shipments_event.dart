part of 'incoming_shipments_bloc.dart';

sealed class IncomingShipmentsEvent extends Equatable {
  const IncomingShipmentsEvent();

  @override
  List<Object> get props => [];
}

class IncomingShipmentsLoadEvent extends IncomingShipmentsEvent {
  final String state;

  IncomingShipmentsLoadEvent(this.state);
}

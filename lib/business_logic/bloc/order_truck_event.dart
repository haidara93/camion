part of 'order_truck_bloc.dart';

class OrderTruckEvent extends Equatable {
  const OrderTruckEvent();

  @override
  List<Object> get props => [];
}

class OrderTruckButtonPressed extends OrderTruckEvent {
  final int driver;
  final int shipment;

  OrderTruckButtonPressed(this.shipment, this.driver);
}

part of 'order_truck_bloc.dart';

class OrderTruckEvent extends Equatable {
  const OrderTruckEvent();

  @override
  List<Object> get props => [];
}

class OrderTruckButtonPressed extends OrderTruckEvent {
  final int driver;

  OrderTruckButtonPressed(this.driver);
}

part of 'order_truck_bloc.dart';

class OrderTruckState extends Equatable {
  const OrderTruckState();

  @override
  List<Object> get props => [];
}

class OrderTruckInitial extends OrderTruckState {}

class OrderTruckLoadingProgressState extends OrderTruckState {}

class OrderTruckSuccessState extends OrderTruckState {
  // final Shipment shipment;

  // OrderTruckSuccessState(this.shipment);
}

class OrderTruckErrorState extends OrderTruckState {
  final String? error;
  const OrderTruckErrorState(this.error);
}

class OrderTruckFailureState extends OrderTruckState {
  final String errorMessage;

  const OrderTruckFailureState(this.errorMessage);
}

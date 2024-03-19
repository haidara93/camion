part of 'managment_shipment_list_bloc.dart';

sealed class ManagmentShipmentListState extends Equatable {
  const ManagmentShipmentListState();

  @override
  List<Object> get props => [];
}

final class ManagmentShipmentListInitial extends ManagmentShipmentListState {}

class ManagmentShipmentListLoadingProgress extends ManagmentShipmentListState {}

class ManagmentShipmentListLoadedSuccess extends ManagmentShipmentListState {
  final List<ManagmentShipment> shipments;

  const ManagmentShipmentListLoadedSuccess(this.shipments);
}

class ManagmentShipmentListLoadedFailed extends ManagmentShipmentListState {
  final String error;

  const ManagmentShipmentListLoadedFailed(this.error);
}

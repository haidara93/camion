part of 'complete_managment_shipment_list_bloc.dart';

sealed class CompleteManagmentShipmentListState extends Equatable {
  const CompleteManagmentShipmentListState();

  @override
  List<Object> get props => [];
}

final class CompleteManagmentShipmentListInitial
    extends CompleteManagmentShipmentListState {}

class CompleteManagmentShipmentListLoadingProgress
    extends CompleteManagmentShipmentListState {}

class CompleteManagmentShipmentListLoadedSuccess
    extends CompleteManagmentShipmentListState {
  final List<ManagmentShipment> shipments;

  const CompleteManagmentShipmentListLoadedSuccess(this.shipments);
}

class CompleteManagmentShipmentListLoadedFailed
    extends CompleteManagmentShipmentListState {
  final String error;

  const CompleteManagmentShipmentListLoadedFailed(this.error);
}

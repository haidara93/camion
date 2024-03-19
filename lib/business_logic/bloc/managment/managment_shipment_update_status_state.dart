part of 'managment_shipment_update_status_bloc.dart';

sealed class ManagmentShipmentUpdateStatusState extends Equatable {
  const ManagmentShipmentUpdateStatusState();

  @override
  List<Object> get props => [];
}

final class ManagmentShipmentUpdateStatusInitial
    extends ManagmentShipmentUpdateStatusState {}

class ManagmentShipmentUpdateStatusLoadingProgress
    extends ManagmentShipmentUpdateStatusState {}

class ManagmentShipmentUpdateStatusLoadedSuccess
    extends ManagmentShipmentUpdateStatusState {}

class ManagmentShipmentUpdateStatusLoadedFailed
    extends ManagmentShipmentUpdateStatusState {
  final String errortext;

  const ManagmentShipmentUpdateStatusLoadedFailed(this.errortext);
}

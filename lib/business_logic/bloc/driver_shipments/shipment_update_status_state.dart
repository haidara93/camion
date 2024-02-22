part of 'shipment_update_status_bloc.dart';

class ShipmentUpdateStatusState extends Equatable {
  const ShipmentUpdateStatusState();

  @override
  List<Object> get props => [];
}

class ShipmentUpdateStatusInitial extends ShipmentUpdateStatusState {}

class ShipmentUpdateStatusLoadingProgress extends ShipmentUpdateStatusState {}

class ShipmentUpdateStatusLoadedSuccess extends ShipmentUpdateStatusState {

  const ShipmentUpdateStatusLoadedSuccess();
}

class ShipmentUpdateStatusLoadedFailed extends ShipmentUpdateStatusState {
  final String errortext;

  const ShipmentUpdateStatusLoadedFailed(this.errortext);
}

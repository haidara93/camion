part of 'shipment_complete_list_bloc.dart';

sealed class ShipmentCompleteListEvent extends Equatable {
  const ShipmentCompleteListEvent();

  @override
  List<Object> get props => [];
}

class ShipmentCompleteListLoadEvent extends ShipmentCompleteListEvent {}

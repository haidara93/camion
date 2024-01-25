part of 'active_shipment_list_bloc.dart';

sealed class ActiveShipmentListEvent extends Equatable {
  const ActiveShipmentListEvent();

  @override
  List<Object> get props => [];
}

class ActiveShipmentListLoadEvent extends ActiveShipmentListEvent {}

part of 'owner_active_shipments_bloc.dart';

sealed class OwnerActiveShipmentsEvent extends Equatable {
  const OwnerActiveShipmentsEvent();

  @override
  List<Object> get props => [];
}

class OwnerActiveShipmentsLoadEvent extends OwnerActiveShipmentsEvent {}

class OwnerActiveShipmentsRefreash extends OwnerActiveShipmentsEvent {}

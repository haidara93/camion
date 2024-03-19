import 'package:bloc/bloc.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'owner_shipment_list_event.dart';
part 'owner_shipment_list_state.dart';

class OwnerShipmentListBloc
    extends Bloc<OwnerShipmentListEvent, OwnerShipmentListState> {
  late ShippmentRerository shippmentRerository;
  OwnerShipmentListBloc({required this.shippmentRerository})
      : super(OwnerShipmentListInitial()) {
    on<OwnerShipmentListLoadEvent>((event, emit) async {
      emit(OwnerShipmentListLoadingProgress());
      try {
        var result =
            await shippmentRerository.getOwnerShipmentList(event.state);
        emit(OwnerShipmentListLoadedSuccess(result));
      } catch (e) {
        emit(OwnerShipmentListLoadedFailed(e.toString()));
      }
    });
  }
}

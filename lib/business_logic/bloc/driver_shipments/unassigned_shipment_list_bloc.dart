import 'package:bloc/bloc.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'unassigned_shipment_list_event.dart';
part 'unassigned_shipment_list_state.dart';

class UnassignedShipmentListBloc
    extends Bloc<UnassignedShipmentListEvent, UnassignedShipmentListState> {
  late ShippmentRerository shippmentRepository;
  UnassignedShipmentListBloc({required this.shippmentRepository})
      : super(UnassignedShipmentListInitial()) {
    on<UnassignedShipmentListLoadEvent>((event, emit) async {
      emit(UnassignedShipmentListLoadingProgress());
      try {
        var result = await shippmentRepository.getUnAssignedShipmentList();
        emit(UnassignedShipmentListLoadedSuccess(result));
      } catch (e) {
        emit(UnassignedShipmentListLoadedFailed(e.toString()));
      }
    });
  }
}

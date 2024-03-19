import 'package:bloc/bloc.dart';
import 'package:camion/data/models/kshipment_model.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'complete_managment_shipment_list_event.dart';
part 'complete_managment_shipment_list_state.dart';

class CompleteManagmentShipmentListBloc extends Bloc<
    CompleteManagmentShipmentListEvent, CompleteManagmentShipmentListState> {
  late ShippmentRerository shippmentRerository;
  CompleteManagmentShipmentListBloc({required this.shippmentRerository})
      : super(CompleteManagmentShipmentListInitial()) {
    on<CompleteManagmentShipmentListLoadEvent>((event, emit) async {
      emit(CompleteManagmentShipmentListLoadingProgress());
      try {
        var result =
            await shippmentRerository.getManagmentKShipmentList(event.state);
        emit(CompleteManagmentShipmentListLoadedSuccess(result));
      } catch (e) {
        emit(CompleteManagmentShipmentListLoadedFailed(e.toString()));
      }
    });
  }
}

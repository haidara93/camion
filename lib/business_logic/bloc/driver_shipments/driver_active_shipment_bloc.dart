import 'package:bloc/bloc.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'driver_active_shipment_event.dart';
part 'driver_active_shipment_state.dart';

class DriverActiveShipmentBloc
    extends Bloc<DriverActiveShipmentEvent, DriverActiveShipmentState> {
  late ShippmentRerository shippmentRerository;
  DriverActiveShipmentBloc({required this.shippmentRerository})
      : super(DriverActiveShipmentInitial()) {
    on<DriverActiveShipmentLoadEvent>((event, emit) async {
      emit(DriverActiveShipmentLoadingProgress());
      try {
        var result =
            await shippmentRerository.getDriverShipmentList(event.state);
        emit(DriverActiveShipmentLoadedSuccess(result));
      } catch (e) {
        emit(DriverActiveShipmentLoadedFailed(e.toString()));
      }
    });
  }
}

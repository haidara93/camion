import 'package:bloc/bloc.dart';
import 'package:camion/data/models/shipmentv2_model.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'shipment_multi_create_event.dart';
part 'shipment_multi_create_state.dart';

class ShipmentMultiCreateBloc
    extends Bloc<ShipmentMultiCreateEvent, ShipmentMultiCreateState> {
  late ShippmentRerository shippmentRerository;
  ShipmentMultiCreateBloc({required this.shippmentRerository})
      : super(ShipmentMultiCreateInitial()) {
    on<ShipmentMultiCreateButtonPressed>((event, emit) async {
      emit(ShippmentLoadingProgressState());
      try {
        var result = await shippmentRerository.createShipmentv2(event.shipment);

        emit(ShipmentMultiCreateSuccessState(result!));
      } catch (e) {
        emit(ShipmentMultiCreateFailureState(e.toString()));
      }
    });
  }
}

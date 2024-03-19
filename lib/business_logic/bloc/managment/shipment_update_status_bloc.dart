import 'package:bloc/bloc.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'shipment_update_status_event.dart';
part 'shipment_update_status_state.dart';

class ShipmentUpdateStatusBloc
    extends Bloc<ShipmentUpdateStatusEvent, ShipmentUpdateStatusState> {
  late ShippmentRerository shippmentRerository;
  ShipmentUpdateStatusBloc({required this.shippmentRerository})
      : super(ShipmentUpdateStatusInitial()) {
    on<ShipmentStatusUpdateEvent>(
      (event, emit) async {
        emit(ShipmentUpdateStatusLoadingProgress());
        try {
          var data = await shippmentRerository.updateKShipmentStatus(
              event.state, event.offerId);
          if (data) {
            emit(ShipmentUpdateStatusLoadedSuccess());
          } else {
            emit(const ShipmentUpdateStatusLoadedFailed("خطأ"));
          }
        } catch (e) {
          emit(ShipmentUpdateStatusLoadedFailed(e.toString()));
        }
      },
    );
  }
}

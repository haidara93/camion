import 'package:bloc/bloc.dart';
import 'package:camion/data/repositories/shipmment_repository.dart';
import 'package:equatable/equatable.dart';

part 'order_truck_event.dart';
part 'order_truck_state.dart';

class OrderTruckBloc extends Bloc<OrderTruckEvent, OrderTruckState> {
  late ShippmentRerository shippmentRerository;
  OrderTruckBloc({required this.shippmentRerository})
      : super(OrderTruckInitial()) {
    on<OrderTruckButtonPressed>((event, emit) async {
      emit(OrderTruckLoadingProgressState());
      try {
        var result = await shippmentRerository.assignDriver(event.driver);

        emit(OrderTruckSuccessState());
      } catch (e) {
        emit(OrderTruckFailureState(e.toString()));
      }
    });
  }
}

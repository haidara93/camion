import 'package:bloc/bloc.dart';
import 'package:camion/data/models/price_request_model.dart';
import 'package:camion/data/repositories/price_request_repository.dart';
import 'package:equatable/equatable.dart';

part 'price_request_event.dart';
part 'price_request_state.dart';

class PriceRequestBloc extends Bloc<PriceRequestEvent, PriceRequestState> {
  late PriceRequestRepository priceRepository;
  PriceRequestBloc({required this.priceRepository})
      : super(PriceRequestInitial()) {
    on<PriceRequestLoadEvent>((event, emit) async {
      emit(PriceRequestLoadingProgress());
      try {
        var result = await priceRepository.getPriceRequests();
        emit(PriceRequestLoadedSuccess(result));
      } catch (e) {
        emit(PriceRequestLoadedFailed(e.toString()));
      }
    });
  }
}

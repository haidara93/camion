import 'package:bloc/bloc.dart';
import 'package:camion/data/models/truck_model.dart';
import 'package:camion/data/repositories/truck_repository.dart';
import 'package:equatable/equatable.dart';

part 'truck_details_event.dart';
part 'truck_details_state.dart';

class TruckDetailsBloc extends Bloc<TruckDetailsEvent, TruckDetailsState> {
  late TruckRepository truckRepository;
  TruckDetailsBloc({required this.truckRepository})
      : super(TruckDetailsInitial()) {
    on<TruckDetailsLoadEvent>((event, emit) async {
      emit(TruckDetailsLoadingProgress());
      try {
        var result = await truckRepository.getTruck(event.id);
        if (result != null) {
          emit(TruckDetailsLoadedSuccess(result!));
        } else {
          emit(TruckDetailsLoadedFailed("error"));
        }
      } catch (e) {
        emit(TruckDetailsLoadedFailed(e.toString()));
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:camion/data/models/truck_model.dart';
import 'package:camion/data/repositories/truck_repository.dart';
import 'package:equatable/equatable.dart';

part 'truck_papers_event.dart';
part 'truck_papers_state.dart';

class TruckPapersBloc extends Bloc<TruckPapersEvent, TruckPapersState> {
  late TruckRepository truckRepository;
  TruckPapersBloc({required this.truckRepository})
      : super(TruckPapersInitial()) {
    on<TruckPapersLoad>((event, emit) async {
      emit(TruckPapersLoadingProgress());
      try {
        var papers = await truckRepository.getTruckPapers(event.truckId);
        emit(TruckPapersLoadedSuccess(papers));
      } catch (e) {
        emit(TruckPapersLoadedFailed(e.toString()));
      }
    });
  }
}

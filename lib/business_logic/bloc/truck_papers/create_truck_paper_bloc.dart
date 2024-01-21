import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camion/data/models/truck_model.dart';
import 'package:camion/data/repositories/truck_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_truck_paper_event.dart';
part 'create_truck_paper_state.dart';

class CreateTruckPaperBloc
    extends Bloc<CreateTruckPaperEvent, CreateTruckPaperState> {
  late TruckRepository truckRepository;
  CreateTruckPaperBloc({required this.truckRepository})
      : super(CreateTruckPaperInitial()) {
    on<CreateTruckPaperButtonPressed>((event, emit) async {
      emit(CreateTruckPaperLoadingProgress());
      try {
        var result =
            await truckRepository.createTruckPapers(event.image, event.paper);
        if (result != null) {
          emit(CreateTruckPaperLoadedSuccess(result));
        } else {
          emit(CreateTruckPaperLoadedFailed("errorstring"));
        }
      } catch (e) {
        emit(CreateTruckPaperLoadedFailed(e.toString()));
      }
    });
  }
}

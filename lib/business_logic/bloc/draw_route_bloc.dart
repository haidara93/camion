import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'draw_route_event.dart';
part 'draw_route_state.dart';

class DrawRouteBloc extends Bloc<DrawRouteEvent, DrawRouteState> {
  DrawRouteBloc() : super(DrawRouteInitial()) {
    on<DrawRoute>((event, emit) async {
      emit(DrawRouteLoading());
      print(state);
      await Future.delayed(Duration(milliseconds: 400));
      emit(DrawRouteSuccess());
      print(state);
    });
  }
}

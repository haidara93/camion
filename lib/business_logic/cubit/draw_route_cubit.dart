import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'draw_route_state.dart';

class DrawRouteCubit extends Cubit<DrawRouteState> {
  DrawRouteCubit() : super(DrawRouteShown());

  void emitShow() {
    emit(DrawRouteShown());
  }

  void emitHide() => emit(DrawRouteHidden());
}

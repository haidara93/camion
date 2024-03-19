import 'package:bloc/bloc.dart';
import 'package:camion/data/models/commodity_category_model.dart';
import 'package:camion/data/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';

part 'simple_category_list_event.dart';
part 'simple_category_list_state.dart';

class SimpleCategoryListBloc
    extends Bloc<SimpleCategoryListEvent, SimpleCategoryListState> {
  late CategoryRepository categoryRepository;
  SimpleCategoryListBloc({required this.categoryRepository})
      : super(SimpleCategoryListInitial()) {
    on<SimpleCategoryListLoadEvent>((event, emit) async {
      emit(SimpleCategoryListLoadingProgress());
      try {
        var result = await categoryRepository.getCommodityCategories();
        emit(SimpleCategoryListLoadedSuccess(result));
      } catch (e) {
        emit(SimpleCategoryListLoadedFailed(e.toString()));
      }
    });
  }
}

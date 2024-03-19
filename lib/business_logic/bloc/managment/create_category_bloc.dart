import 'package:bloc/bloc.dart';
import 'package:camion/data/models/commodity_category_model.dart';
import 'package:camion/data/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  late CategoryRepository categoryRepository;
  CreateCategoryBloc({required this.categoryRepository})
      : super(CreateCategoryInitial()) {
    on<CreateCategoryButtonPressedEvent>((event, emit) async {
      emit(CreateCategoryLoadingProgress());
      try {
        var result = await categoryRepository.createCategory(event.category);
        if (result) {
          emit(CreateCategoryLoadedSuccess());
        } else {
          emit(const CreateCategoryLoadedFailed("error"));
        }
      } catch (e) {
        emit(CreateCategoryLoadedFailed(e.toString()));
      }
    });
  }
}

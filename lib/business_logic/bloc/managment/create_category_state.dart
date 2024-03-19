part of 'create_category_bloc.dart';

sealed class CreateCategoryState extends Equatable {
  const CreateCategoryState();

  @override
  List<Object> get props => [];
}

final class CreateCategoryInitial extends CreateCategoryState {}

class CreateCategoryLoadingProgress extends CreateCategoryState {}

class CreateCategoryLoadedSuccess extends CreateCategoryState {}

class CreateCategoryLoadedFailed extends CreateCategoryState {
  final String error;

  const CreateCategoryLoadedFailed(this.error);
}

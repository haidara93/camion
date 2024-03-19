part of 'simple_category_list_bloc.dart';

sealed class SimpleCategoryListState extends Equatable {
  const SimpleCategoryListState();

  @override
  List<Object> get props => [];
}

final class SimpleCategoryListInitial extends SimpleCategoryListState {}

class SimpleCategoryListLoadingProgress extends SimpleCategoryListState {}

class SimpleCategoryListLoadedSuccess extends SimpleCategoryListState {
  final List<SimpleCategory> categories;

  const SimpleCategoryListLoadedSuccess(this.categories);
}

class SimpleCategoryListLoadedFailed extends SimpleCategoryListState {
  final String error;

  const SimpleCategoryListLoadedFailed(this.error);
}

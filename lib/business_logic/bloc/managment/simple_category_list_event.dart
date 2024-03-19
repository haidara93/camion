part of 'simple_category_list_bloc.dart';

sealed class SimpleCategoryListEvent extends Equatable {
  const SimpleCategoryListEvent();

  @override
  List<Object> get props => [];
}

class SimpleCategoryListLoadEvent extends SimpleCategoryListEvent {}

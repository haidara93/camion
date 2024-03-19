part of 'search_category_list_bloc.dart';

sealed class SearchCategoryListEvent extends Equatable {
  const SearchCategoryListEvent();

  @override
  List<Object> get props => [];
}

class SearchKCommodityCategoryEvent extends SearchCategoryListEvent {
  final String query;

  SearchKCommodityCategoryEvent({required this.query});
}

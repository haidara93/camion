part of 'search_category_list_bloc.dart';

sealed class SearchCategoryListState extends Equatable {
  const SearchCategoryListState();

  @override
  List<Object> get props => [];
}

final class SearchCategoryListInitial extends SearchCategoryListState {}

class SearchCategoryListLoadingProgress extends SearchCategoryListState {}

class SearchCategoryListLoadedSuccess extends SearchCategoryListState {
  final List<KCommodityCategory> commodityCategories;

  SearchCategoryListLoadedSuccess(this.commodityCategories);
}

class SearchCategoryListLoadedFailed extends SearchCategoryListState {
  final String errortext;

  const SearchCategoryListLoadedFailed(this.errortext);
}

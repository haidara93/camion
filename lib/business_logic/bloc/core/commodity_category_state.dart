part of 'commodity_category_bloc.dart';

sealed class CommodityCategoryState extends Equatable {
  const CommodityCategoryState();

  @override
  List<Object> get props => [];
}

final class CommodityCategoryInitial extends CommodityCategoryState {}

class CommodityCategoryLoadingProgress extends CommodityCategoryState {}

class CommodityCategoryLoadedSuccess extends CommodityCategoryState {
  final List<CommodityCategory> commodityCategories;

  const CommodityCategoryLoadedSuccess(this.commodityCategories);
}

class CommodityCategoryLoadedFailed extends CommodityCategoryState {
  final String errortext;

  const CommodityCategoryLoadedFailed(this.errortext);
}

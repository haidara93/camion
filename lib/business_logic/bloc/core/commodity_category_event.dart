part of 'commodity_category_bloc.dart';

sealed class CommodityCategoryEvent extends Equatable {
  const CommodityCategoryEvent();

  @override
  List<Object> get props => [];
}

class CommodityCategoryLoadEvent extends CommodityCategoryEvent {}

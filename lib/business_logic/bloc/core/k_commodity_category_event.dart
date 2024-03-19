part of 'k_commodity_category_bloc.dart';

sealed class KCommodityCategoryEvent extends Equatable {
  const KCommodityCategoryEvent();

  @override
  List<Object> get props => [];
}

class KCommodityCategoryLoadEvent extends KCommodityCategoryEvent {}

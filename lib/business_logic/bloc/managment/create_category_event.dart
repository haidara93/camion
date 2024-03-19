part of 'create_category_bloc.dart';

sealed class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategoryButtonPressedEvent extends CreateCategoryEvent {
  final KCommodityCategory category;

  CreateCategoryButtonPressedEvent({required this.category});
}

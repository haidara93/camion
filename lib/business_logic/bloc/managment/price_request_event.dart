part of 'price_request_bloc.dart';

sealed class PriceRequestEvent extends Equatable {
  const PriceRequestEvent();

  @override
  List<Object> get props => [];
}

class PriceRequestLoadEvent extends PriceRequestEvent {
 
}

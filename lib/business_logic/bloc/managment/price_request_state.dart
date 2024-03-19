part of 'price_request_bloc.dart';

sealed class PriceRequestState extends Equatable {
  const PriceRequestState();

  @override
  List<Object> get props => [];
}

final class PriceRequestInitial extends PriceRequestState {}

class PriceRequestLoadingProgress extends PriceRequestState {}

class PriceRequestLoadedSuccess extends PriceRequestState {
  final List<PriceRequestDetails> pricerequest;

  const PriceRequestLoadedSuccess(this.pricerequest);
}

class PriceRequestLoadedFailed extends PriceRequestState {
  final String error;

  const PriceRequestLoadedFailed(this.error);
}

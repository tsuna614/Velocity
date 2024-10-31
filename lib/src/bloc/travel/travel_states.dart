import 'package:velocity_app/src/model/travel_model.dart';

abstract class TravelState {}

class TravelInitial extends TravelState {}

class TravelLoading extends TravelState {}

class TravelFailure extends TravelState {
  final String message;

  TravelFailure({required this.message});
}

class TravelLoaded extends TravelState {
  final List<TravelModel> travels;

  TravelLoaded({required this.travels});

  TravelLoaded copyWith({
    List<TravelModel>? travels,
  }) {
    return TravelLoaded(
      travels: travels ?? this.travels,
    );
  }
}

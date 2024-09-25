import 'package:velocity_app/src/model/travel_model.dart';

class TravelState {}

class TravelInitial extends TravelState {}

class TravelLoading extends TravelState {}

class TravelLoaded extends TravelState {
  // final List<Tour> tours;
  // final List<Hotel> hotels;
  // final List<Flight> flights;
  // final List<CarRental> carRentals;

  // TravelLoaded(
  //     {this.tours = const [],
  //     this.hotels = const [],
  //     this.flights = const [],
  //     this.carRentals = const []});

  // TravelLoaded copyWith({
  //   List<Tour>? tours,
  //   List<Hotel>? hotels,
  //   List<Flight>? flights,
  //   List<CarRental>? carRentals,
  // }) {
  //   return TravelLoaded(
  //     tours: tours ?? this.tours,
  //     hotels: hotels ?? this.hotels,
  //     flights: flights ?? this.flights,
  //     carRentals: carRentals ?? this.carRentals,
  //   );
  // }

  final List<Travel> travels;

  TravelLoaded({required this.travels});

  TravelLoaded copyWith({
    List<Travel>? travels,
  }) {
    return TravelLoaded(
      travels: travels ?? this.travels,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import './dummy_data.dart' as dummyData;

///////////// Dummy Data /////////////

///////////// Tour Bloc /////////////
class TravelState {
  final List<Tour> tours;
  final List<Hotel> hotels;
  final List<Flight> flights;
  final List<CarRental> carRentals;

  TravelState(
      {this.tours = const [],
      this.hotels = const [],
      this.flights = const [],
      this.carRentals = const []});

  TravelState copyWith({
    List<Tour>? tours,
    List<Hotel>? hotels,
    List<Flight>? flights,
    List<CarRental>? carRentals,
  }) {
    return TravelState(
      tours: tours ?? this.tours,
      hotels: hotels ?? this.hotels,
      flights: flights ?? this.flights,
      carRentals: carRentals ?? this.carRentals,
    );
  }
}

abstract class TravelEvent {}

class LoadData extends TravelEvent {}

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  TravelBloc() : super(TravelState(tours: [])) {
    on<LoadData>((event, emit) {
      emit(TravelState(
          tours: dummyData.tours,
          hotels: dummyData.hotels,
          flights: dummyData.flights,
          carRentals: dummyData.carRentals));
    });
  }
}

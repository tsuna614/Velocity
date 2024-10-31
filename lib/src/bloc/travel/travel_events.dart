import 'package:velocity_app/src/model/travel_model.dart';

abstract class TravelEvent {}

class LoadData extends TravelEvent {}

class AddTravel extends TravelEvent {
  final TravelModel travel;

  AddTravel(this.travel);
}

class UpdateTour extends TravelEvent {
  final Tour tour;

  UpdateTour(this.tour);
}

class UpdateHotel extends TravelEvent {
  final Hotel hotel;

  UpdateHotel(this.hotel);
}

class UpdateFlight extends TravelEvent {
  final Flight flight;

  UpdateFlight(this.flight);
}

class UpdateCarRental extends TravelEvent {
  final CarRental carRental;

  UpdateCarRental(this.carRental);
}

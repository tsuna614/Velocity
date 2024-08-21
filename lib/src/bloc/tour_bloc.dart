import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/model/tour_model.dart';

///////////// Dummy Data /////////////
List<Tour> tours = [
  Tour(
    name: 'Paris',
    description:
        'Paris is the capital city of France. It is situated on the River Seine, in northern France, at the heart of the Île-de-France region.',
    imageUrl: [
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
    ],
    destination: 'France',
    city: 'Paris',
    price: 2000,
    rating: 4.5,
    duration: '3 days 2 nights',
  ),
  Tour(
    name: 'London',
    description:
        'London is the capital and largest city of England and the United Kingdom. It stands on the River Thames in south-east England at the head of a 50-mile (80 km) estuary down to the North Sea.',
    imageUrl: [
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
    ],
    destination: 'United Kingdom',
    city: 'London',
    price: 2500,
    rating: 4.7,
    duration: '4 days 3 nights',
  ),
  Tour(
    name: 'New York',
    description:
        'New York City (NYC), often simply called New York, is the most populous city in the United States. With an estimated 2019 population of 8,336,817 distributed over about 302.6 square miles (784 km2), New York is also the most densely populated major city in the United States.',
    imageUrl: [
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
      'https://images.unsplash.com/photo-1560260832-0b3b5f9e3f6f',
    ],
    destination: 'United States',
    city: 'New York',
    price: 3000,
    rating: 4.8,
    duration: '5 days 4 nights',
  ),
];

///////////// Tour Bloc /////////////
class TourState {
  final List<Tour> tours;

  TourState({required this.tours});
}

abstract class TourEvent {}

class LoadTours extends TourEvent {}

class TourBloc extends Bloc<TourEvent, TourState> {
  TourBloc() : super(TourState(tours: [])) {
    on<LoadTours>((event, emit) {
      print("object");
      emit(TourState(tours: tours));
    });
  }
}

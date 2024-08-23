import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/model/tour_model.dart';

///////////// Dummy Data /////////////
List<Tour> tours = [
  Tour(
    title: 'Paris',
    description:
        'Paris is the capital city of France. It is situated on the River Seine, in northern France, at the heart of the Île-de-France region.',
    imageUrl: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2c/07/a8/2c/caption.jpg?w=1400&h=1400&s=1',
    ],
    destination: 'France',
    city: 'Paris',
    price: 2000,
    rating: 3.0,
    duration: '3 days 2 nights',
  ),
  Tour(
    title: 'London',
    description:
        'London is the capital and largest city of England and the United Kingdom. It stands on the River Thames in south-east England at the head of a 50-mile (80 km) estuary down to the North Sea.',
    imageUrl: [
      'https://i0.wp.com/worldonwheelsblog.com/wp-content/uploads/2024/01/the-tower-bridge-scaled.jpg?fit=2560%2C1920&ssl=1'
    ],
    destination: 'United Kingdom',
    city: 'London',
    price: 2500,
    rating: 4.7,
    duration: '4 days 3 nights',
  ),
  Tour(
    title: 'New York',
    description:
        'New York City (NYC), often simply called New York, is the most populous city in the United States. With an estimated 2019 population of 8,336,817 distributed over about 302.6 square miles (784 km2), New York is also the most densely populated major city in the United States.',
    imageUrl: [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/New_york_times_square-terabass.jpg/640px-New_york_times_square-terabass.jpg'
    ],
    destination: 'United States',
    city: 'New York',
    price: 3000,
    rating: 4.8,
    duration: '5 days 4 nights',
  ),
  Tour(
    title: 'Tokyo',
    description:
        'Tokyo, officially Tokyo Metropolis, is the capital of Japan and one of its 47 prefectures. The Greater Tokyo Area is the most populous metropolitan area in the world.',
    imageUrl: ['https://www.japan-guide.com/g18/3004_01.jpg'],
    destination: 'Japan',
    city: 'Tokyo',
    price: 3500,
    rating: 5,
    duration: '6 days 5 nights',
  ),
];

List<Hotel> hotels = [
  Hotel(
    title: 'Hilton Hotel',
    description:
        'Hilton Hotels & Resorts is a global brand of full-service hotels and resorts and the flagship brand of American multinational hospitality company Hilton.',
    imageUrl: [
      'https://images.bubbleup.com/width1920/quality35/mville2017/1-brand/1-margaritaville.com/gallery-media/220803-compasshotel-medford-pool-73868-1677873697-78625-1694019828.jpg'
    ],
    city: 'Amsterdam',
    price: 200,
    rating: 3.0,
    address: 'Apollolaan 138, 1077 BG Amsterdam, Netherlands',
    contact: '+31 20 710 6000',
  ),
  Hotel(
    title: 'The Ritz-Carlton',
    description:
        'The Ritz-Carlton Hotel Company, LLC is an American multinational company that operates the luxury hotel chain known as The Ritz-Carlton.',
    imageUrl: [
      'https://www.newworldhotels.com/wp-content/uploads/2014/05/Mobile-NWHBR-Exterior.jpg'
    ],
    city: 'Miami',
    price: 250,
    rating: 4.7,
    address: '455 Grand Bay Dr, Key Biscayne, FL 33149, United States',
    contact: '+1 305-365-4500',
  ),
];

///////////// Tour Bloc /////////////
class TravelState {
  final List<Tour> tours;
  final List<Hotel> hotels;

  TravelState({this.tours = const [], this.hotels = const []});

  TravelState copyWith({
    List<Tour>? tours,
    List<Hotel>? hotels,
  }) {
    return TravelState(
      tours: tours ?? this.tours,
      hotels: hotels ?? this.hotels,
    );
  }
}

abstract class TravelEvent {}

class LoadData extends TravelEvent {}

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  TravelBloc() : super(TravelState(tours: [])) {
    on<LoadData>((event, emit) {
      emit(TravelState(tours: tours, hotels: hotels));
    });
  }
}

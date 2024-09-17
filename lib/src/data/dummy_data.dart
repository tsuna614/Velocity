import 'package:uuid/uuid.dart';
import 'package:velocity_app/src/model/post_model.dart';
import 'package:velocity_app/src/model/travel_model.dart';

var uuid = Uuid();

List<Tour> tours = [
  Tour(
    id: uuid.v4(),
    title: 'London sightseeing tour',
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
    id: uuid.v4(),
    title: 'Paris sightseeing tour',
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
    id: uuid.v4(),
    title: 'New York sightseeing tour',
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
    id: uuid.v4(),
    title: 'Tokyo sightseeing tour',
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
    id: uuid.v4(),
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
  Hotel(
    id: uuid.v4(),
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
];

List<Flight> flights = [
  Flight(
    id: uuid.v4(),
    title: 'Direct Flight to New York',
    description: 'Enjoy a comfortable direct flight to New York City.',
    imageUrl: [
      'https://assets.fta.cirium.com/wp-content/uploads/2023/01/24164258/Delta-Air-Lines-Airbus-A350-900-ed.jpg'
    ],
    price: 300.0,
    rating: 4.5,
    origin: 'Los Angeles, CA',
    destination: 'New York, NY',
    departureTime: '08:00 AM',
    arrivalTime: '04:00 PM',
    airline: 'Delta Airlines',
  ),
  Flight(
    id: uuid.v4(),
    title: 'Economy Flight to London',
    description: 'Affordable flight to London with excellent services.',
    imageUrl: [
      'https://media.cntraveler.com/photos/577fcc03e0b5a6244f4c789c/master/pass/BritishAirways-Boeing777-AlamyF1KW8J.jpg'
    ],
    price: 450.0,
    rating: 4.3,
    origin: 'Boston, MA',
    destination: 'London, UK',
    departureTime: '09:30 PM',
    arrivalTime: '09:00 AM',
    airline: 'British Airways',
  ),
  Flight(
    id: uuid.v4(),
    title: 'Luxury Flight to Dubai',
    description: 'Experience luxury travel with our exclusive flight to Dubai.',
    imageUrl: [
      'https://content.presspage.com/uploads/2431/1920_emiratesa380-3.jpg?10000'
    ],
    price: 1200.0,
    rating: 4.9,
    origin: 'San Francisco, CA',
    destination: 'Dubai, UAE',
    departureTime: '10:00 PM',
    arrivalTime: '08:00 PM',
    airline: 'Emirates Airlines',
  ),
  Flight(
    id: uuid.v4(),
    title: 'Red-eye Flight to Tokyo',
    description: 'Convenient overnight flight to Tokyo.',
    imageUrl: [
      'https://www.nerdwallet.com/assets/blog/wp-content/uploads/2021/05/Japan-Airline-article-aircraft-770x462.jpeg'
    ],
    price: 800.0,
    rating: 4.7,
    origin: 'Chicago, IL',
    destination: 'Tokyo, Japan',
    departureTime: '11:45 PM',
    arrivalTime: '01:30 AM',
    airline: 'Japan Airlines',
  ),
  Flight(
    id: uuid.v4(),
    title: 'Budget Flight to Paris',
    description: 'Affordable travel option for your next trip to Paris.',
    imageUrl: [
      'https://img.static-af.com/images/media/5D2B8853-2A1B-4F90-863CE72ED6E0B489/?w=1440'
    ],
    price: 550.0,
    rating: 4.4,
    origin: 'Miami, FL',
    destination: 'Paris, France',
    departureTime: '06:00 PM',
    arrivalTime: '08:00 AM',
    airline: 'Air France',
  ),
];

List<CarRental> carRentals = [
  CarRental(
    id: uuid.v4(),
    title: 'Luxury SUV Rental',
    description:
        'Rent a luxurious SUV with top features for your next adventure.',
    imageUrl: [
      'https://www.carmudi.vn/_next/image/?url=https://static.carmudi.vn/wp-content/uploads/2023-02/4dTYOHUMap.jpg&w=1200&q=75'
    ],
    price: 150.0,
    rating: 4.8,
    location: 'Los Angeles, CA',
    contact: '555-1234',
    carType: 'SUV',
  ),
  CarRental(
    id: uuid.v4(),
    title: 'Economy Car Rental',
    description: 'Affordable and efficient car for city driving.',
    imageUrl: [
      'https://hips.hearstapps.com/hmg-prod/images/34-2019-impreza-premium-5-door-1559828997.jpg'
    ],
    price: 45.0,
    rating: 4.2,
    location: 'New York, NY',
    contact: '555-5678',
    carType: 'Economy',
  ),
  CarRental(
    id: uuid.v4(),
    title: 'Convertible Sports Car',
    description: 'Experience the thrill of driving a convertible sports car.',
    imageUrl: [
      'https://www.autocar.co.uk/sites/autocar.co.uk/files/mercedes-amg-sl-top-10_0_0.jpg'
    ],
    price: 200.0,
    rating: 4.9,
    location: 'Miami, FL',
    contact: '555-8765',
    carType: 'Convertible',
  ),
  CarRental(
    id: uuid.v4(),
    title: 'Minivan Rental',
    description: 'Spacious minivan for family trips and group travels.',
    imageUrl: ['https://cdn.jdpower.com/Most%20Reliable%20Minivans.jpg'],
    price: 75.0,
    rating: 4.5,
    location: 'Orlando, FL',
    contact: '555-4321',
    carType: 'Minivan',
  ),
  CarRental(
    id: uuid.v4(),
    title: 'Luxury Sedan Rental',
    description: 'Rent a premium sedan for business or pleasure.',
    imageUrl: [
      'https://cimg3.ibsrv.net/ibimg/hgm/1600x900-1/100/561/cadillac-escala-concept_100561247.jpg'
    ],
    price: 120.0,
    rating: 4.7,
    location: 'San Francisco, CA',
    contact: '555-3456',
    carType: 'Sedan',
  ),
];

List<MyPost> dummyPosts = [
  MyPost(
    postId: uuid.v4(),
    userId: '66d81aa5592d9cbcdfe445b4',
    content: "I'm going to Paris next week!",
    imageUrl:
        'https://cimg3.ibsrv.net/ibimg/hgm/1600x900-1/100/561/cadillac-escala-concept_100561247.jpg',
  ),
  MyPost(
    postId: uuid.v4(),
    userId: '66d81aa5592d9cbcdfe445b4',
    content: "I'm going to Paris next week!",
    imageUrl:
        'https://cimg3.ibsrv.net/ibimg/hgm/1600x900-1/100/561/cadillac-escala-concept_100561247.jpg',
  ),
  MyPost(
    postId: uuid.v4(),
    userId: '66d81aa5592d9cbcdfe445b4',
    content: "I'm going to Paris next week!",
    imageUrl:
        'https://cimg3.ibsrv.net/ibimg/hgm/1600x900-1/100/561/cadillac-escala-concept_100561247.jpg',
  ),
];

import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/travel_model.dart';

class TravelApi {
  final baseUrl = GlobalData.baseUrl;
  final dio = Dio();

  Future<List<Travel>> fetchTravelData() async {
    try {
      final response = await dio.get('$baseUrl/travel/getAllTravels');

      List<Travel> travels = [];

      response.data.forEach((travel) {
        switch (travel['travelType']) {
          case "tour":
            travels.add(Tour.fromJson(travel));
            break;
          case "hotel":
            travels.add(Hotel.fromJson(travel));
            break;
          case "flight":
            travels.add(Flight.fromJson(travel));
            break;
          case "carRental":
            travels.add(CarRental.fromJson(travel));
            break;
          default:
        }
      });

      return travels;
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message,
      );
    }
  }
}

class GeneralApi {
  // List<Travel> getTravelDataOfType(
  //     {required BuildContext context, required TravelType dataType}) {
  //   switch (dataType) {
  //     case TravelType.tour:
  //       return BlocProvider.of<TravelBloc>(context).state.tours;
  //     case TravelType.hotel:
  //       return BlocProvider.of<TravelBloc>(context).state.hotels;
  //     case TravelType.flight:
  //       return BlocProvider.of<TravelBloc>(context).state.flights;
  //     case TravelType.car:
  //       return BlocProvider.of<TravelBloc>(context).state.carRentals;
  //     default:
  //       return [];
  //   }
  // }

  // List<Travel> getAllTraveldata({required BuildContext context}) {
  //   final travelBloc = BlocProvider.of<TravelBloc>(context);
  //   return [
  //     ...travelBloc.state.tours,
  //     ...travelBloc.state.hotels,
  //     ...travelBloc.state.flights,
  //     ...travelBloc.state.carRentals,
  //   ];
  // }
}

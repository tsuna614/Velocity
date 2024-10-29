import 'package:dio/dio.dart';
import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/services/api_response.dart';

abstract class TravelApi {
  Future<ApiResponse<List<Travel>>> fetchTravelData();
}

class TravelApiImpl extends TravelApi {
  final baseUrl = GlobalData.baseUrl;
  final dio = Dio();

  @override
  Future<ApiResponse<List<Travel>>> fetchTravelData() async {
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

      return ApiResponse(data: travels);
    } on DioException catch (e) {
      return ApiResponse(errorMessage: e.message);
    }
  }
}

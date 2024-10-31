import 'package:velocity_app/src/data/global_data.dart';
import 'package:velocity_app/src/model/travel_model.dart';
import 'package:velocity_app/src/services/api_service.dart';

abstract class TravelApi {
  final ApiService apiService;
  TravelApi(this.apiService);

  Future<ApiResponse<List<TravelModel>>> fetchTravelData();
}

class TravelApiImpl extends TravelApi {
  final baseUrl = GlobalData.baseUrl;

  TravelApiImpl(super.apiService);

  @override
  Future<ApiResponse<List<TravelModel>>> fetchTravelData() async {
    return apiService.get(
        endpoint: "$baseUrl/travel/getAllTravels",
        fromJson: (data) {
          List<TravelModel> travels = [];

          data.forEach((travel) {
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
        });
  }
}

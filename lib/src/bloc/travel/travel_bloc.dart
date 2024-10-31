import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_app/src/services/api_service.dart';
import 'package:velocity_app/src/services/travel_api.dart';
import 'package:velocity_app/src/bloc/travel/travel_events.dart';
import 'package:velocity_app/src/bloc/travel/travel_states.dart';
import 'package:velocity_app/src/model/travel_model.dart';

///////////// Dummy Data /////////////

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  final TravelApi travelApi;

  TravelBloc(this.travelApi) : super(TravelInitial()) {
    on<LoadData>((event, emit) async {
      emit(TravelLoading());
      final ApiResponse<List<Travel>> response =
          await travelApi.fetchTravelData();

      if (response.errorMessage != null) {
        emit(TravelFailure(message: response.errorMessage!));
      } else {
        emit(TravelLoaded(travels: response.data!));
      }
    });
  }
}

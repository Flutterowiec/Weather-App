// forecast_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_bloc_app/bloc/weather/weather_event.dart';
import 'package:weather_bloc_app/bloc/weather/weather_state.dart';

import 'package:weather_bloc_app/services/cache_service.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(ForecastInitial()) {
    on<FetchForecast>((event, emit) async {
      emit(ForecastLoading());

      final cacheService = CacheService(
        event.longitude ?? 0.0,
        event.latitude ?? 0.0,
      );
      final forecastResponse = await cacheService.GetForecastData(
          event.UseCacheOnly, event.isRefresh);
      if (forecastResponse.forecastList.isNotEmpty) {
        emit(ForecastLoaded(forecastResponse));
      } else {
        emit(ForecastError("No forecast data received"));
      }
    });
  }
}

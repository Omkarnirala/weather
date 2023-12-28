import 'package:flutter_bloc/flutter_bloc.dart';

import '../API Service/weather_service.dart';
import '../model/weather.dart';

abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String cityName;
  FetchWeather(this.cityName);
}

class ResetWeather extends WeatherEvent {}

// Define States
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded(this.weather);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

// BLoC Implementation
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService;

  WeatherBloc({required this.weatherService}) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final Weather weather = await weatherService.fetchWeather(event.cityName);
        emit(WeatherLoaded(weather));
      } catch (error) {
        emit(WeatherError("Failed to fetch weather"));
      }
    });

    // Add handlers for other events if needed
  }
}

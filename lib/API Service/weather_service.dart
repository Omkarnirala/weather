
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/error.dart';
import '../model/weather.dart';

class WeatherService {
  final http.Client httpClient;
  WeatherService({required this.httpClient});

  Future<Weather> fetchWeather(String cityName) async {
    final response = await httpClient.get(Uri.parse('https://api.weatherapi.com/v1/current.json?q=$cityName&key="YOUR_API_KEY"&aqi=yes'));

    if (response.statusCode == 200) {
      final weatherJson = json.decode(response.body);
      return Weather.fromJson(weatherJson);
    } else {
      throw WeatherError.fromJson(json.decode(response.body));
    }
  }
}

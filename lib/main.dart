import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'API Service/weather_service.dart';
import 'bloc/weather_bloc.dart';
import 'model/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather App'),
      ),
      body: BlocProvider(
        create: (context) => WeatherBloc(
          weatherService: WeatherService(httpClient: http.Client()),
        ),
        child: const WeatherWidget(),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});


  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final TextEditingController _cityController = TextEditingController();
  String? _errorMessage;
  Map<String, String>? _weatherResponse;

  void _validateAndFetchWeather() {
    if (_cityController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a city name');
    } else {
      setState(() {
        _errorMessage = null;
        BlocProvider.of<WeatherBloc>(context)
            .add(FetchWeather(_cityController.text));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCityInputField(),
        _buildFetchWeatherButton(),
        _buildWeatherResponseView(),
      ],
    );
  }

  Widget _buildCityInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: TextField(
        controller: _cityController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Enter a city name',
          errorText: _errorMessage,
        ),
      ),
    );
  }

  Widget _buildFetchWeatherButton() {
    return ElevatedButton(
      onPressed: _validateAndFetchWeather,
      child: const Text('Get Weather'),
    );
  }

  Widget _buildWeatherResponseView() {
    return Expanded(
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            _weatherResponse = _buildWeatherInfo(state.weather);
            return _buildWeatherDisplay();
          } else if (state is WeatherError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
            );
          }
          return Container(); // For initial state or when no response is present
        },
      ),
    );
  }

  Map<String, String> _buildWeatherInfo(Weather weather) {
    String locationInfo = 'Location Information:\n'
        '1. Name: ${weather.location.name}\n'
        '2. Region: ${weather.location.region}\n'
        '3. Country: ${weather.location.country}\n'
        '4. Coordinates: Latitude ${weather.location.lat}, Longitude ${weather.location.lon}\n'
        '5. Local Time: ${weather.location.localtime}\n\n';

    String currentWeatherInfo = 'Current Weather:\n'
        '1. Temperature: ${weather.current.tempC}°C / ${weather.current.tempF}°F\n'
        '2. Condition: ${weather.current.condition.text}\n'
        '3. Wind: ${weather.current.windMph} mph (${weather.current.windKph} kph), Direction: ${weather.current.windDir}\n'
        '4. Humidity: ${weather.current.humidity}%\n'
        '5. Pressure: ${weather.current.pressureMb} mb (${weather.current.pressureIn} in)\n'
        '6. Precipitation: ${weather.current.precipMm} mm (${weather.current.precipIn} in)\n'
        '7. Cloud Cover: ${weather.current.cloud}%\n'
        '8. Feels Like: ${weather.current.feelslikeC}°C / ${weather.current.feelslikeF}°F\n'
        '9. Visibility: ${weather.current.visKm} km (${weather.current.visMiles} miles)\n'
        '10. UV Index: ${weather.current.uv}\n'
        '11. Gust: ${weather.current.gustMph} mph (${weather.current.gustKph} kph)\n\n';

    String airQualityInfo = 'Air Quality:\n'
        '1. Index (US EPA): ${weather.current.airQuality.usEpaIndex}\n'
        '2. Index (GB DEFRA): ${weather.current.airQuality.gbDefraIndex}\n'
        '3. CO: ${weather.current.airQuality.co} μg/m³\n'
        '4. NO2: ${weather.current.airQuality.no2} μg/m³\n'
        '5. O3: ${weather.current.airQuality.o3} μg/m³\n'
        '6. SO2: ${weather.current.airQuality.so2} μg/m³\n'
        '7. PM2.5: ${weather.current.airQuality.pm2_5} μg/m³\n'
        '8. PM10: ${weather.current.airQuality.pm10} μg/m³\n';

    String infoText = locationInfo + currentWeatherInfo + airQualityInfo;
    String iconUrl = "http:${weather.current.condition.icon}";

    return {'infoText': infoText, 'iconUrl': iconUrl};
  }

  Widget _buildWeatherDisplay() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_weatherResponse?['iconUrl'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.network(_weatherResponse!['iconUrl']!),
            ),
          Text(_weatherResponse?['infoText'] ?? ""),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}

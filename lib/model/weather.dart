/*
class Weather {
  final String cityName;
  final double temperature;
  // Add other fields as necessary

  Weather({required this.cityName, required this.temperature});

  // Parse JSON data
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      // Parse other fields
    );
  }
}*/

class Weather {
  final Location location;
  final CurrentWeather current;

  Weather({required this.location, required this.current});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    location: Location.fromJson(json['location']),
    current: CurrentWeather.fromJson(json['current']),
  );
}

class Location {
  final String name, region, country, tzId, localtime;
  final double lat, lon;
  final int localtimeEpoch;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json['name'],
    region: json['region'],
    country: json['country'],
    lat: json['lat'].toDouble(),
    lon: json['lon'].toDouble(),
    tzId: json['tz_id'],
    localtimeEpoch: json['localtime_epoch'],
    localtime: json['localtime'],
  );
}

class CurrentWeather {
  final int lastUpdatedEpoch, isDay, windDegree, humidity, cloud;
  final String lastUpdated, windDir;
  final double tempC, tempF, windMph, windKph, pressureMb, pressureIn, precipMm, precipIn, feelslikeC, feelslikeF, visKm, visMiles, uv, gustMph, gustKph;
  final Condition condition;
  final AirQuality airQuality;

  CurrentWeather({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
    required this.airQuality,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    lastUpdatedEpoch: json['last_updated_epoch'],
    lastUpdated: json['last_updated'],
    tempC: json['temp_c'].toDouble(),
    tempF: json['temp_f'].toDouble(),
    isDay: json['is_day'],
    condition: Condition.fromJson(json['condition']),
    windMph: json['wind_mph'].toDouble(),
    windKph: json['wind_kph'].toDouble(),
    windDegree: json['wind_degree'],
    windDir: json['wind_dir'],
    pressureMb: json['pressure_mb'].toDouble(),
    pressureIn: json['pressure_in'].toDouble(),
    precipMm: json['precip_mm'].toDouble(),
    precipIn: json['precip_in'].toDouble(),
    humidity: json['humidity'],
    cloud: json['cloud'],
    feelslikeC: json['feelslike_c'].toDouble(),
    feelslikeF: json['feelslike_f'].toDouble(),
    visKm: json['vis_km'].toDouble(),
    visMiles: json['vis_miles'].toDouble(),
    uv: json['uv'].toDouble(),
    gustMph: json['gust_mph'].toDouble(),
    gustKph: json['gust_kph'].toDouble(),
    airQuality: AirQuality.fromJson(json['air_quality']),
  );
}

class Condition {
  final String text, icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
    text: json['text'],
    icon: json['icon'],
    code: json['code'],
  );
}

class AirQuality {
  final double co, no2, o3, so2, pm2_5, pm10;
  final int usEpaIndex, gbDefraIndex;

  AirQuality({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.usEpaIndex,
    required this.gbDefraIndex,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) => AirQuality(
    co: json['co'].toDouble(),
    no2: json['no2'].toDouble(),
    o3: json['o3'].toDouble(),
    so2: json['so2'].toDouble(),
    pm2_5: json['pm2_5'].toDouble(),
    pm10: json['pm10'].toDouble(),
    usEpaIndex: json['us-epa-index'],
    gbDefraIndex: json['gb-defra-index'],
  );
}


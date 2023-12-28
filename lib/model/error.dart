class WeatherError {
  final String message;

  WeatherError({required this.message});

  // Define the fromJson method
  factory WeatherError.fromJson(Map<String, dynamic> json) {
    return WeatherError(
      message: json['message'] ?? 'Unknown error', // Replace 'message' with the actual key in your JSON response
    );
  }
}
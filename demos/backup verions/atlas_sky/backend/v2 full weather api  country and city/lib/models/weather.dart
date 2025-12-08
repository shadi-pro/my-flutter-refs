class Weather {
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json["main"]["temp"] ?? 0).toDouble(),
      description: (json["weather"] != null && json["weather"].isNotEmpty)
          ? json["weather"][0]["description"] ?? "N/A"
          : "N/A",
      icon: (json["weather"] != null && json["weather"].isNotEmpty)
          ? json["weather"][0]["icon"] ?? "01d"
          : "01d",
      feelsLike: (json["main"]["feels_like"] ?? 0).toDouble(),
      humidity: (json["main"]["humidity"] ?? 0).toInt(),
      windSpeed: (json["wind"]["speed"] ?? 0).toDouble(),
    );
  }
}

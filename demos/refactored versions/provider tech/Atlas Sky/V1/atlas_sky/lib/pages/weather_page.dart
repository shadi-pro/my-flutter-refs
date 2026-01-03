import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../providers/weather_provider.dart';
import '../models/weather.dart';

class WeatherPage extends StatefulWidget {
  final String city;
  final String? countryCode;

  const WeatherPage({super.key, required this.city, this.countryCode});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider = Provider.of<WeatherProvider>(
        context,
        listen: false,
      );
      weatherProvider.fetchWeather(
        widget.city,
        countryCode: widget.countryCode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final title = widget.countryCode != null
        ? "Weather in ${widget.city}, ${widget.countryCode}"
        : "Weather in ${widget.city}";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => weatherProvider.fetchWeather(
              widget.city,
              countryCode: widget.countryCode,
            ),
          ),
        ],
      ),
      body: weatherProvider.isLoading
          ? const LoadingWidget(message: "Fetching weather data...")
          : weatherProvider.error != null
          ? ErrorDisplayWidget(
              error: weatherProvider.error!,
              onRetry: () => weatherProvider.fetchWeather(
                widget.city,
                countryCode: widget.countryCode,
              ),
            )
          : GradientBackground(
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: weatherProvider.currentWeather == null
                        ? const Text("No weather data available")
                        : _buildWeatherContent(weatherProvider.currentWeather!),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildWeatherContent(Weather weather) {
    // ✅ Now Weather is recognized
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${weather.temperature.toStringAsFixed(1)} °C",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade50,
          child: Image.network(
            "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
            width: 70,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.cloud, size: 40, color: Colors.blueAccent),
          ),
        ),
        const SizedBox(height: 20),
        Text("Humidity: ${weather.humidity}%"),
        Text("Wind: ${weather.windSpeed} m/s"),
        Text("Feels like: ${weather.feelsLike.toStringAsFixed(1)} °C"),
      ],
    );
  }
}

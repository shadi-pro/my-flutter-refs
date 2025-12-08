import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';

class WeatherPage extends StatefulWidget {
  final String city;
  final String? countryCode; // optional country code

  const WeatherPage({super.key, required this.city, this.countryCode});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _service = WeatherService();
  Weather? weather;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _service.fetchWeather(
        widget.city,
        countryCode: widget.countryCode,
      );
      setState(() {
        weather = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            "Weather data not available for ${widget.city}${widget.countryCode != null ? ', ${widget.countryCode}' : ''}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.countryCode != null
        ? "Weather in ${widget.city}, ${widget.countryCode}"
        : "Weather in ${widget.city}";

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.blueAccent),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.blue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${weather?.temperature ?? '--'} °C",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          weather?.description?.toUpperCase() ?? "N/A",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade50,
                          child:
                              (weather?.icon != null &&
                                  weather!.icon.isNotEmpty)
                              ? Image.network(
                                  "https://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                                  width: 70,
                                )
                              : const Icon(
                                  Icons.cloud,
                                  size: 40,
                                  color: Colors.blueAccent,
                                ),
                        ),
                        const SizedBox(height: 20),
                        if (weather?.humidity != null)
                          Text("Humidity: ${weather!.humidity}%"),
                        if (weather?.windSpeed != null)
                          Text("Wind: ${weather!.windSpeed} m/s"),
                        if (weather?.feelsLike != null)
                          Text("Feels like: ${weather!.feelsLike} °C"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/country_service.dart';

class CountryPage extends StatefulWidget {
  final String countryName;

  const CountryPage({super.key, required this.countryName});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final CountryService _service = CountryService();
  Map<String, dynamic>? country;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCountry();
  }

  Future<void> _fetchCountry() async {
    try {
      final data = await _service.fetchCountry(widget.countryName);
      setState(() {
        country = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Country: ${widget.countryName}")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
            ? Text("Error: $errorMessage")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    country!["name"]["common"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Capital: ${country!["capital"]?[0] ?? "N/A"}"),
                  Text("Region: ${country!["region"]}"),
                  Text("Population: ${country!["population"]}"),
                  const SizedBox(height: 20),
                  Image.network(country!["flags"]["png"], width: 120),
                ],
              ),
      ),
    );
  }
}

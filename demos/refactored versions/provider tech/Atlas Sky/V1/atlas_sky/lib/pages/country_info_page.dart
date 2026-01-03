import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryInfoPage extends StatelessWidget {
  final Country country;

  const CountryInfoPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${country.name} Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      country.flagUrl,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.flag, size: 100, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow("Name", country.name),
                  _buildInfoRow("ISO Code", country.isoCode),
                  if (country.capital != null)
                    _buildInfoRow("Capital", country.capital!),
                  _buildInfoRow("Region", country.region),
                  _buildInfoRow("Population", country.population.toString()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}

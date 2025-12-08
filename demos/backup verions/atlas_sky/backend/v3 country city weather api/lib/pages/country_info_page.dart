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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    country.flagUrl,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Name: ${country.name}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "ISO Code: ${country.isoCode}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Capital: ${country.capital}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Region: ${country.region}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Population: ${country.population}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Country {
  final String name;
  final String? capital;
  final String region;
  final int population;
  final String flagUrl;
  final String isoCode;

  Country({
    required this.name,
    this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
    required this.isoCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: (json["name"] != null && json["name"]["common"] != null)
          ? json["name"]["common"]
          : "Unknown",
      capital:
          (json["capital"] != null &&
              json["capital"] is List &&
              json["capital"].isNotEmpty)
          ? json["capital"][0]
          : null,
      region: json["region"] ?? "Unknown",
      population: json["population"] ?? 0,
      flagUrl: (json["flags"] != null && json["flags"]["png"] != null)
          ? json["flags"]["png"]
          : "",
      isoCode: json["cca2"] ?? "", // ISO alpha‑2 code
    );
  }
}

class AppConstants {
  // API Keys (should be moved to environment variables)
  static const String geoDbApiKey =
      "507860880bmshedb57401613ce29p179e98jsnbc8e4958e779";
  static const String weatherApiKey = "6a92ead34ea06ce955603a0af83f5155";

  // API Endpoints
  static const String countriesApi = "https://restcountries.com/v3.1";
  static const String geoDbApi = "https://wft-geo-db.p.rapidapi.com/v1/geo";
  static const String weatherApi = "https://api.openweathermap.org/data/2.5";

  // Cache durations (in seconds)
  static const int countryCacheDuration = 3600; // 1 hour
  static const int cityCacheDuration = 1800; // 30 minutes
  static const int weatherCacheDuration = 300; // 5 minutes

  // SharedPreferences keys
  static const String prefSelectedCountry = 'selected_country';
  static const String prefSelectedCity = 'selected_city';
  static const String prefThemeMode = 'theme_mode';
  static const String prefRecentSearches = 'recent_searches';
}

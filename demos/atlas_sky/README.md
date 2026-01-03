# atlas_sky

A new Flutter project.

## Getting Started


###  project structure : 
 
 lib/
├── main.dart
├── models/ (unchanged)
│   ├── country.dart
│   └── weather.dart
├── services/
│   ├── country_service.dart
│   ├── city_service.dart
│   └── weather_service.dart
├── pages/
    ├── home_page.dart
    ├── country_page.dart
    ├── country_info_page.dart
    └── weather_page.dart
     
 

 ### 🚀 Provided Features:
Country Search: Search countries by name with REST Countries API

Country Details: View flag, capital, region, population, ISO code

City List: Get major cities for selected country using GeoDB API

Weather Information: Get weather data for selected city using OpenWeatherMap API

Multi-step Navigation: Home → Country → City Selection → Weather


### 🛠 Tech Stack Before Refactoring:
State Management: Basic setState() with local widget state

API Integration: Direct HTTP calls in services

Navigation: Manual Navigator.push() calls

Architecture: MVC-like with services + widgets



### Dependencies:

http: For API calls

No state management library

No persistence layer



### ⚙️ Backend Services Used:
REST Countries API: Country information and flags

GeoDB Cities API: City lists by country code

OpenWeatherMap API: Weather data with metric units

API Keys: Embedded in service files (security concern)


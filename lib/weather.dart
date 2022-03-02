import 'dart:convert';

import 'package:http/http.dart';

import 'environment.dart';

class Weather {
  int temp; // 気温
  int tempMax; // 最高気温
  int tempMin; // 最低気温
  String description; // 天気の状態
  double lon; // 経度
  double lat; // 緯度
  String icon; // 天気情報のアイコン画像
  DateTime? time; // 日時
  int rainyPercent; // 降水確率

  Weather(
      {this.temp = 0,
      this.tempMax = 0,
      this.tempMin = 0,
      this.description = '',
      this.lon = 0.0,
      this.lat = 0.0,
      this.icon = '',
      this.time,
      this.rainyPercent = 0});

  static String publicParameter =
      'lang=ja&units=metric&appid=${EnvironmentVariables.openWeatherMapApiKey}';

  static Future<Weather?> getCurrentWeather(String zipCode) async {
    String _zipCode;
    if (zipCode.contains('-')) {
      _zipCode = zipCode;
    } else {
      _zipCode = zipCode.substring(0, 3) + '-' + zipCode.substring(3);
    }
    String url =
        'https://api.openweathermap.org/data/2.5/weather?zip=${_zipCode},JP&${publicParameter}';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      Weather currentWeather = Weather(
          description: data['weather'][0]['description'],
          temp: data['main']['temp'].toInt(),
          tempMax: data['main']['temp_max'].toInt(),
          tempMin: data['main']['temp_min'].toInt(),
          lon: data['coord']['lon'],
          lat: data['coord']['lat']);
      return currentWeather;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, List<Weather>>> getForecast(
      {double? lon, double? lat}) async {
    String url =
        'https://api.openweathermap.org/data/2.5/onecall?lon=${lon}&lat=${lat}&exclude=minutely&${publicParameter}';
    Map<String, List<Weather>> response = {};
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      // Get Hourly Data
      List<dynamic> hourlyWeatherData = data['hourly'];
      List<Weather> hourlyWeather = hourlyWeatherData.map((weather) {
        return Weather(
          time: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          icon: weather['weather'][0]['icon'],
          temp: weather['temp'].toInt(),
        );
      }).toList();
      response['hourly'] = hourlyWeather;
      // Get Daily Data
      List<dynamic> dailyWeatherData = data['daily'];
      List<Weather> dailyWeather = dailyWeatherData.map((weather) {
        return Weather(
          time: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          icon: weather['weather'][0]['icon'],
          tempMax: weather['temp']['max'].toInt(),
          tempMin: weather['temp']['min'].toInt(),
          rainyPercent:
              weather.containsKey('rain') ? weather['rain'].toInt() : 0,
        );
      }).toList();
      response['daily'] = dailyWeather;
      return response;
    } catch (e) {
      print(e);
      return response;
    }
  }
}

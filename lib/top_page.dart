import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/weather.dart';
import 'package:weather_forecast/zip_code.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather? currentWeather = Weather();

  List<Weather> hourlyWeather = [];
  List<Weather> dailyWeather = [];

  List<String> weekDay = ['月', '火', '水', '木', '金', '土', '日'];
  String address = '-';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                width: 200,
                child: TextField(
                  onSubmitted: (value) async {
                    Map<String, String> response = {};
                    response = await ZipCode.searchAddressFromZipCode(value);
                    if (response.containsKey('address')) {
                      address = response['address']!;
                      currentWeather = await Weather.getCurrentWeather(value);
                      Map<String, List<Weather>> weatherForecast =
                          await Weather.getForecast(
                              lon: currentWeather!.lon,
                              lat: currentWeather!.lat);
                      hourlyWeather = weatherForecast['hourly']!;
                      dailyWeather = weatherForecast['daily']!;
                      errorMessage = '';
                    } else {
                      errorMessage = response['message']!;
                    }
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: '郵便番号を入力'),
                )),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Text(address, style: TextStyle(fontSize: 26)),
            Text(currentWeather!.description),
            Text('${currentWeather!.temp}°', style: TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('最高: ${currentWeather!.tempMax}°')),
                Text('最低: ${currentWeather!.tempMin}°')
              ],
            ),
            SizedBox(height: 20),
            Divider(height: 0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: hourlyWeather.map((weather) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Text('${DateFormat('H').format(weather.time!)}時'),
                      Text(
                        '${weather.rainyPercent}%',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                      Image.network(
                          'https://openweathermap.org/img/wn/${weather.icon}.png',
                          width: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${weather.temp}°',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                );
              }).toList()),
            ),
            Divider(height: 0),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                      children: dailyWeather.map((weather) {
                    return Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text(
                                  '${weekDay[weather.time!.weekday - 1]}曜日'),
                              width: 50),
                          Row(
                            children: [
                              Container(
                                width: 35,
                              ),
                              Image.network(
                                  'https://openweathermap.org/img/wn/${weather.icon}.png',
                                  width: 30),
                              Container(
                                width: 35,
                                child: Text('${weather.rainyPercent}%',
                                    style: TextStyle(color: Colors.lightBlue)),
                              ),
                            ],
                          ),
                          Container(
                            width: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${weather.tempMax}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),
                                Text(
                                  '${weather.tempMin}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.4)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

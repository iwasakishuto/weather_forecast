import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/weather.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather currentWeather =
      Weather(temp: 15, description: '晴れ', tempMax: 18, tempMin: 14);

  List<Weather> hourlyWeather = [
    Weather(
        temp: 15,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 10),
        rainyPercent: 80),
    Weather(
        temp: 12,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 11),
        rainyPercent: 40),
    Weather(
        temp: 17,
        description: '曇り',
        time: DateTime(2021, 10, 1, 12),
        rainyPercent: 30),
  ];

  List<Weather> dailyWeather = [
    Weather(
        tempMax: 20, tempMin: 26, rainyPercent: 0, time: DateTime(2021, 10, 1)),
    Weather(
        tempMax: 20, tempMin: 26, rainyPercent: 0, time: DateTime(2021, 10, 2)),
    Weather(
        tempMax: 20, tempMin: 26, rainyPercent: 0, time: DateTime(2021, 10, 3)),
    Weather(
        tempMax: 20, tempMin: 26, rainyPercent: 0, time: DateTime(2021, 10, 4)),
    Weather(
        tempMax: 20, tempMin: 26, rainyPercent: 0, time: DateTime(2021, 10, 5)),
    
  ];

  List<String> weekDay = ['月', '火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 200,
                child: TextField(
                  onSubmitted: (value) {
                    print(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '郵便番号を入力'
                  ),
                ))
            ,
            SizedBox(height: 50),
            Text('大阪市', style: TextStyle(fontSize: 26)),
            Text(currentWeather.description),
            Text('${currentWeather.temp}°', style: TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('最高: ${currentWeather.tempMax}°')),
                Text('最低: ${currentWeather.tempMin}°')
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
                      Icon(Icons.wb_sunny_sharp),
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
                  child: Column(children: dailyWeather.map((weather) {
                    return Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: Text('${weekDay[weather.time!.weekday - 1]}曜日'), color: Colors.red, width: 50),
                          Row(
                            children: [
                              Icon(Icons.wb_sunny_sharp),
                              Text('${weather.rainyPercent}%',
                                  style: TextStyle(color: Colors.lightBlue)),
                            ],
                          ),
                          Container(
                            width: 50,
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${weather.tempMax}', style: TextStyle(fontSize: 16,)),
                                Text('${weather.tempMin}', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.4)),)
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

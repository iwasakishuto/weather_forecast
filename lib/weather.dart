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

  Weather({
    this.temp = 0, this.tempMax = 0, this.tempMin = 0,  this.description = '',
    this.lon = 0.0, this.lat = 0.0, this.icon = '', this.time, this.rainyPercent = 0
  });
}

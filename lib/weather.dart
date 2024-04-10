import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  final String city;

  Weather({required this.city});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Map<String, dynamic>? currentWeather;
  List<dynamic> forecastData = [];
  final String apiKey = 'f6a1775bf8bc647827a8c1edbdaa0628'; // Replace with your OpenWeatherMap API key

  Icon getWeatherIcon(String weather) {
    final lowerCaseWeather = weather.toLowerCase();

    if (lowerCaseWeather.contains('rain')) {
      return Icon(Icons.beach_access);
    }
    if (lowerCaseWeather.contains('snow')) {
      return Icon(Icons.ac_unit);
    }
    if (lowerCaseWeather.contains('clear')) {
      return Icon(Icons.wb_sunny);
    }
    if (lowerCaseWeather.contains('clouds')) {
      return Icon(Icons.cloud);
    }

    switch (lowerCaseWeather) {
      case 'sunny':
        return Icon(Icons.wb_sunny);
      case 'overcast clouds':
        return Icon(Icons.cloud_circle);
      case 'snow':
        return Icon(Icons.ac_unit);
      case 'thunderstorm':
        return Icon(Icons.flash_on);
      case 'drizzle':
        return Icon(Icons.grain);
      default:
        return Icon(Icons.help);
    }
  }

  Future<void> fetchData() async {
    final String city = widget.city.isNotEmpty ? widget.city : 'New York';
    print(city);
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        currentWeather = data;
      });
      print(currentWeather);

      http.Response forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric'));
      Map<String, dynamic> forecastDataMap = json.decode(forecastResponse.body);
      setState(() {
        forecastData = forecastDataMap['list'];
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return currentWeather != null
        ? Column(
            children: [
              Text(
                widget.city.toUpperCase(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Text(
                    'Current Weather',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getWeatherIcon(currentWeather!['weather'][0]['description']),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Temperature: ${currentWeather!['main']['temp']}°C'),
                          Text('Weather: ${currentWeather!['weather'][0]['description']}'),
                          Text('Wind Speed: ${currentWeather!['wind']['speed']} m/s'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '5-Day Weather Forecast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: forecastData.isNotEmpty
                          ? forecastData
                              .where((forecast) => forecast['dt_txt'].endsWith('15:00:00'))
                              .map<Widget>((forecast) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(forecast['dt_txt'].split(' ')[0]),
                                    getWeatherIcon(forecast['weather'][0]['description']),
                                    Text(forecast['weather'][0]['description']),
                                    Text('${forecast['main']['temp']}°C'),
                                  ],
                                ),
                              );
                            }).toList()
                          : [Text('No Results...')],
                    ),
                  ),
                ],
              ),
            ],
          )
        : CircularProgressIndicator();
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Weather App'),
//       ),
//       body: Weather(city: 'New York'),
//     ),
//   ));
// }

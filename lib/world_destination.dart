import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:place/world_place.dart';
import 'package:place/weather.dart';

class WorldDestination extends StatefulWidget {
  @override
  _WorldDestinationState createState() => _WorldDestinationState();
}

class _WorldDestinationState extends State<WorldDestination> {
  TextEditingController _placeController = TextEditingController();
  String _city = "";
  List<dynamic> _places = [];
  String _placeName = "";

  // String apiKey = '5ae2e3f221c38a28845f05b6defb8d26c271159c861f61b9ba77a581';
  // String lang = 'en';
  // String xid = "R11801445";

  // String _detailUrl =
  //     'https://api.opentripmap.com/0.1/$lang/places/xid/$xid?apikey=$apiKey';
  // String _url =
  //     'https://api.opentripmap.com/0.1/$lang/places/geoname?apikey=$apiKey';

  late String lang;
  late String xid;
  late String apiKey;
  late String detailUrl;
  late String url;

  @override
  void initState() {
    super.initState();
    lang = 'en';
    apiKey = '5ae2e3f221c38a28845f05b6defb8d26c271159c861f61b9ba77a581';
    xid = 'R11801445';
    detailUrl = 'https://api.opentripmap.com/0.1/en/places/xid/R11801445?apikey=5ae2e3f221c38a28845f05b6defb8d26c271159c861f61b9ba77a581';
    url = 'https://api.opentripmap.com/0.1/en/places/geoname?apikey=5ae2e3f221c38a28845f05b6defb8d26c271159c861f61b9ba77a581';
  }

  // void initializeUrls() {
  //   detailUrl = 'https://api.opentripmap.com/0.1/$lang/places/xid/$xid?apikey=$apiKey';
  //   url = 'https://api.opentripmap.com/0.1/$lang/places/geoname?apikey=$apiKey';
  // }
  Future<void> _handleSubmit() async {
    setState(() {
      _city = _placeName;
    });

    try {
      http.Response response = await http.get(Uri.parse('$url&name=$_placeName'));
      Map<String, dynamic> data = json.decode(response.body);
      double lon = data['lon'];
      double lat = data['lat'];

      http.Response res = await http.get(Uri.parse(
          'https://api.opentripmap.com/0.1/en/places/bbox?lon_min=${lon - 0.01}&lat_min=${lat - 0.01}&lon_max=${lon + 0.01}&lat_max=${lat + 0.01}&apikey=$apiKey'));

      setState(() {
        _places = json.decode(res.body)['features'];
      });
      print(_places);
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('World Destination'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _placeController,
              onChanged: (value) {
                setState(() {
                  _placeName = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter city ...',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Submit'),
            ),
            Weather(city: _city),
            Expanded(
      child: ListView.builder(
        itemCount: _places.length,
        itemBuilder: (context, index) {
          // final xid = _places[index]['xid']; // Assuming 'xid' is the key for xid
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorldPlace(_places[index]['properties']['xid']), // Pass xid to WorldPlace
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(_places[index]['properties']['name']),
              ),
            ),
          );
        },
      ),
    )
          ],
        ),
      ),
    );
  }
}



void main() {
  runApp(MaterialApp(
    home: WorldDestination(),
  ));
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorldPlace extends StatefulWidget {
  final String xid; // Add xid as a parameter

  WorldPlace(this.xid); // Constructor to accept xid

  @override
  _WorldPlaceState createState() => _WorldPlaceState();
}

class _WorldPlaceState extends State<WorldPlace> {
  Map<String, dynamic> _place = {};
  late String apiKey;
  late String lang;
  late String detailUrl;

  @override
  void initState() {
    super.initState();
    apiKey = '5ae2e3f221c38a28845f05b6defb8d26c271159c861f61b9ba77a581';
    lang = 'en';
    detailUrl = 'https://api.opentripmap.com/0.1/$lang/places/xid/${widget.xid}?apikey=$apiKey';
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(detailUrl));
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _place = data;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_place['name'] ?? 'Loading...'),
      ),
      body: _place.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _place['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (_place['preview'] != null && _place['preview']['source'] != null)
                    Image.network(
                      _place['preview']['source'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 10),
                  if (_place['kinds'] != null)
                    Text(
                      'Category: ${_place['kinds'].split(",").join(", ")}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 10),
                  Text(
                    'Address:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (_place['address'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (_place['address'] as Map<String, dynamic>).entries
                          .map((entry) => Text('${entry.key}: ${entry.value}'))
                          .toList(),
                    ),
                  SizedBox(height: 10),
                  if (_place['rate'] != null) Text('Rating: ${_place['rate']}'),
                  if (_place['url'] != null)
                    Text('Website: ${_place['url']}'),
                  if (_place['wikipedia'] != null)
                    Text('Wikipedia: ${_place['wikipedia']}'),
                  if (_place['wikipedia_extracts'] != null && _place['wikipedia_extracts']['text'] != null)
                    Text('${_place['wikipedia_extracts']['text']}'),
                ],
              ),
            ),
    );
  }
}

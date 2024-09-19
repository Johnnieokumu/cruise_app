import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MapService {
  MapService._instantiate();

  static final MapService instance = MapService._instantiate();
  final String _baseUrl = 'maps.googleapis.com';
  static const String MapAPI_KEY = 'AIzaSyBsXgSHQBgcQ7uV9nBUSEX_UlfHGYo4JZE';

  // Method to get directions between two locations
  Future<Map<String, dynamic>> getDirections({
    required String origin,
    required String destination,
    String mode = 'driving',
  }) async {
    final uri = Uri.https(
      _baseUrl,
      '/maps/api/directions/json',
      {
        'origin': origin,
        'destination': destination,
        'mode': mode,
        'key': MapAPI_KEY,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    else {
      throw HttpException('Failed to load directions');
    }
  }
  //Method to get nearby places based on a keyword
  Future <Map<String, dynamic>> getNearbyPlaces({
    required String location,
    required String keyword,
    String radius = '1500',
  }) async {
    final uri = Uri.https(
      _baseUrl,
      '/maps/api/place/nearbysearch/json',
      {
        'location': location,
        'keyword': keyword,
        'radius': radius,
        'key': MapAPI_KEY,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpException('Failed to load nearby places');

    }
  }
  //Method to calculate distance between two locations
  Future<Map<String, dynamic>> getDistanceMatrix({
    required String origins,
    required String destinations,
    String mode = 'driving',
  }) async { 
    final uri = Uri.https(
    _baseUrl,
    '/maps/api/distancematrix/json',
    {
      'origins': origins,
      'destinations': destinations,
      'mode': mode,
      'key': MapAPI_KEY,
    },
  
  );
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw HttpException('Failed to load distance matrix');
  }
  }
}
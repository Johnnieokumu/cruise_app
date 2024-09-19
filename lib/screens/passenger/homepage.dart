import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cruise_app/services/map.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final MapService _mapService = MapService.instance;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData _locationData = await location.getLocation();

    setState(() {
      _currentPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });

    // Fetch nearby places and update markers
    _fetchNearbyPlaces();
  }

  Future<void> _fetchNearbyPlaces() async {
    try {
      if (_currentPosition != null) {
        final nearbyPlaces = await _mapService.getNearbyPlaces(
          location: '${_currentPosition!.latitude},${_currentPosition!.longitude}',
          keyword: 'restaurant', // Example keyword
        );

        if (nearbyPlaces['results'] != null) {
          setState(() {
            _markers.addAll(
              (nearbyPlaces['results'] as List).map(
                (place) {
                  final lat = place['geometry']['location']['lat'];
                  final lng = place['geometry']['location']['lng'];
                  return Marker(
                    markerId: MarkerId(place['place_id']),
                    position: LatLng(lat, lng),
                    infoWindow: InfoWindow(title: place['name']),
                  );
                },
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Failed to fetch nearby places: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cruise App'),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14.0,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: _handleMapTap,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );
    });
  }

  void _goToCurrentLocation() {
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14.0),
        ),
      );
    }
  }
}

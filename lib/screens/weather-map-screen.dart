import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../widgets/back-arrow-button.dart';

class WeatherMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherMapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  Position? position;
  final openStreamMap = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  final azureMap =
      'https://atlas.microsoft.com/map/imagery/png?subscription-key=cGa7L0uUNMtWSynLLodATxxh7A8HDJvYX8dv29TUhJ0&api-version=1.0&style=satellite&zoom={z}&x={x}&y={y}';

  LocationData? currentLocation;
  String address = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SfMaps(
            layers: [
              MapTileLayer(
                urlTemplate: azureMap,
                initialFocalLatLng:
                    MapLatLng(widget.latitude, widget.longitude),
                initialZoomLevel: 15,
              ),
            ],
          ),
          BackArrowButton(onPressed: () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }
}

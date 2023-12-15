// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../models/city.dart';
// import '../models/day-weather.dart';
//
// class WeatherMapScreen extends StatelessWidget {
//   final City city;
//   final DayWeather dayWeather;
//
//   const WeatherMapScreen(
//       {Key? key, required this.dayWeather, required this.city})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // double? latitude = double.tryParse(dayWeather.latitude);
//     // double? longitude = double.tryParse(dayWeather.longitude);
//
//     if (dayWeather.latitude != null && dayWeather.longitude != null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Weather Map - ${city.cityName}'),
//         ),
//         body: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(dayWeather.latitude, dayWeather.longitude),
//             zoom: 12,
//           ),
//           markers: {
//             Marker(
//               markerId: MarkerId(city.cityName),
//               position: LatLng(dayWeather.latitude, dayWeather.longitude),
//               infoWindow: InfoWindow(title: city.cityName),
//             ),
//           },
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Error'),
//         ),
//         body: Center(
//           child:
//               Text('Invalid latitude or longitude values for ${city.cityName}'),
//         ),
//       );
//     }
//   }
// }

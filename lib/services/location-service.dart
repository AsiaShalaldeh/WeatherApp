import 'package:geocode/geocode.dart' as geocode;
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';

class LocationService {
  Future<LocationData?> GetLocation() async {
    Location location = new Location();
    LocationData _locationData;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<Address> GetAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return Address();
    GeoCode geoCode = GeoCode();
    geocode.Address address =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    // return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
    return address;
  }
}

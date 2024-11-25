import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placeMarks.isNotEmpty) {
      Placemark place = placeMarks[0];
      return '${place.street} , ${place.locality}, ${place.subAdministrativeArea}';
    }
    return "Address not found";
  } catch (e) {
    return "Error getting address $e";
  }
}

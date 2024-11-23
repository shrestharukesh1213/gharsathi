import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key});

  @override
  State<LocationSelectScreen> createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  final MapController mapController = MapController();
  LatLng? currentLocation;
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    //Gets the users current location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    bool locationServiceEnabled;
    LocationPermission permission;

    permission = await Geolocator.requestPermission();
    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (kDebugMode) {
      print(permission);
      print(locationServiceEnabled);
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        if (!locationServiceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );

          return;
        }

        Position position = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best));

        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
          isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapController.move(currentLocation!, 15.0);
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateUserLocation(
      String? uid, double latitude, double longitude) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      await userDoc.update({
        'location': {'latitude': latitude, 'longitude': longitude}
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Updated user location successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select your Location"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLocation != null) {
            if (user != null) {
              updateUserLocation(user!.uid, currentLocation!.latitude,
                  currentLocation!.longitude);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Select a Location')),
            );
          }
        },
        elevation: 6,
        tooltip: "Confirm and Save Location",
        child: const Icon(Icons.check),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  initialCenter:
                      //Sets location to Kathmandu if currentLocation is not available
                      currentLocation ?? const LatLng(27.7103, 85.3222),
                  initialZoom: 15.0,
                  maxZoom: 19.0,
                  minZoom: 4.0,
                  onTap: (_, point) {
                    setState(() => currentLocation = point);
                  }),
              children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.gharsathi',
                  ),
                  MarkerLayer(
                      markers: currentLocation != null
                          ? [
                              Marker(
                                point: currentLocation!,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              )
                            ]
                          : []),
                ]),
    );
  }
}

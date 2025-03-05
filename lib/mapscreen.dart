// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   MapboxMapController? _mapController;
//   Location location = Location();
//   LatLng? _currentLocation;

//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }

//   Future<void> _getLocation() async {
//     try {
//       var locationData = await location.getLocation();
//       setState(() {
//         _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
//       });

//       if (_mapController != null && _currentLocation != null) {
//         _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentLocation == null
//           ? const Center(child: CircularProgressIndicator())
//           : MapboxMap(
//               accessToken:
//                   "pk.eyJ1IjoiaGFyc2h2c3MiLCJhIjoiY2x1cjQ5eTdxMDNxYjJpbjBoM2JwN2llYSJ9.bXR-Xw8Cn0suHXrgG_Sgnw",
//               onMapCreated: (controller) {
//                 _mapController = controller;
//                 if (_currentLocation != null) {
//                   _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
//                 }
//               },
//               initialCameraPosition: CameraPosition(
//                 target: _currentLocation ?? LatLng(0, 0), // Default to (0,0) until location updates
//                 zoom: 14.0,
//               ),
//             ),
//     );
//   }
// }

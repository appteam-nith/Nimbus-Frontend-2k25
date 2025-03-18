// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';

// // Dummy provider for team markers (Replace with your actual provider)
// final teamMarkersProvider = Provider<List<Marker>>((ref) => []);

// class MapWidget extends ConsumerStatefulWidget {
//   const MapWidget({Key? key}) : super(key: key);

//   @override
//   _MapWidgetState createState() => _MapWidgetState();
// }

// class _MapWidgetState extends ConsumerState<MapWidget> {
//   late final MapController _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//   }

//   void _centerMapToInitialPosition() {
//     _mapController.move(LatLng(31.7070, 76.5263), 17);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final markers = ref.watch(teamMarkersProvider);

//     return Stack(
//       children: [
//         FlutterMap(
//           mapController: _mapController,
//           options: MapOptions(
//             initialCenter: LatLng(31.7070, 76.5263),
//             initialZoom: 17.5, // Fixed property
//             interactionOptions: const InteractionOptions(
//               flags: InteractiveFlag.all &
//                   ~InteractiveFlag.pinchZoom &
//                   ~InteractiveFlag.doubleTapZoom,
//             ),
//           ),
//           children: [
//             TileLayer(
//               urlTemplate:
//                   'https://api.mapbox.com/styles/v1/harshvss/clur4jhs701dg01pihy490el6/tiles/256/{z}/{x}/{y}@2x?access_token=YOUR_ACCESS_TOKEN',
//             ),
//             MarkerLayer(markers: markers),
//           ],
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: IconButton(
//               color: Colors.white,
//               iconSize: 30,
//               onPressed: _centerMapToInitialPosition,
//               icon: const Icon(Icons.my_location_sharp, color: Colors.black),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _mapController.dispose();
//     super.dispose();
//   }
// }

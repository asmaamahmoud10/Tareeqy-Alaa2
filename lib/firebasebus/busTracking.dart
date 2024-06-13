// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusTrackingScreen extends StatelessWidget {
  final String busId;

  const BusTrackingScreen(this.busId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Tracking'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Drivers')
            .where('busId', isEqualTo: busId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<Marker> markers = [];
          snapshot.data!.docs.forEach((doc) {
            double latitude = doc['latitude'];
            double longitude = doc['longitude'];
            markers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(title: doc['busId']),
              ),
            );
          });

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target:
                  LatLng(0, 0), // Initial position (e.g., center of the map)
              zoom: 10.0, // Initial zoom level
            ),
            markers: Set<Marker>.of(markers),
          );
        },
      ),
    );
  }
}

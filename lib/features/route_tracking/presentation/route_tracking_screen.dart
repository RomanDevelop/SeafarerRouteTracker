import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

import '../application/route_notifier.dart';
import '../domain/route_model.dart';

class RouteTrackingScreen extends ConsumerWidget {
  const RouteTrackingScreen({super.key});

  Future<bool> _checkNetworkAvailability() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false; // Сеть недоступна
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(routeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Route Tracking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<bool>(
        future: _checkNetworkAvailability(),
        builder: (context, networkSnapshot) {
          if (networkSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final isNetworkAvailable = networkSnapshot.data ?? false;

          return FutureBuilder<Position>(
            future: ref.read(routeProvider.notifier).getCurrentPosition(),
            builder: (context, positionSnapshot) {
              if (positionSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (positionSnapshot.hasError) {
                return Center(child: Text('Error: ${positionSnapshot.error}'));
              }

              final currentPosition = positionSnapshot.data;

              return Stack(
                children: [
                  // Если сеть недоступна, отображаем error_map.png вместо карты
                  if (!isNetworkAvailable)
                    Center(
                      child: Image.asset(
                        'assets/error_map.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    FlutterMap(
                      options: MapOptions(
                        crs: const Epsg3857(),
                        initialCenter: currentPosition != null
                            ? LatLng(currentPosition.latitude,
                                currentPosition.longitude)
                            : const LatLng(50.5, 30.51),
                        initialZoom: routeState.zoomLevel,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        ),
                        MarkerLayer(markers: _createMarkers(routeState)),
                        PolylineLayer(polylines: _createPolylines(routeState)),
                      ],
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildDistanceInfo(context, ref, routeState),
                  ),
                  // Кнопки для зума
                  Positioned(
                    top: 100,
                    right: 10,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "zoomIn",
                          onPressed: () {
                            ref.read(routeProvider.notifier).zoomIn();
                          },
                          child: const Icon(Icons.zoom_in),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton(
                          heroTag: "zoomOut",
                          onPressed: () {
                            ref.read(routeProvider.notifier).zoomOut();
                          },
                          child: const Icon(Icons.zoom_out),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: routeState.start != null && routeState.end == null
                        ? _buildInProgressRoute()
                        : _buildStartRouteButton(context, ref),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Marker> _createMarkers(RouteModel routeState) {
    final markers = <Marker>[];

    if (routeState.start != null) {
      markers.add(Marker(
        point: LatLng(routeState.start!.latitude, routeState.start!.longitude),
        child: const Icon(Icons.circle, color: Colors.green, size: 40),
      ));
    }

    if (routeState.end != null) {
      markers.add(Marker(
        point: LatLng(routeState.end!.latitude, routeState.end!.longitude),
        child: const Icon(Icons.flag, color: Colors.red, size: 40),
      ));
    }

    return markers;
  }

  List<Polyline> _createPolylines(RouteModel routeState) {
    final polylines = <Polyline>[];

    if (routeState.start != null && routeState.end != null) {
      polylines.add(Polyline(
        points: [
          LatLng(routeState.start!.latitude, routeState.start!.longitude),
          LatLng(routeState.end!.latitude, routeState.end!.longitude),
        ],
        color: Colors.blue,
        strokeWidth: 4.0,
      ));
    }

    return polylines;
  }

  Widget _buildDistanceInfo(
      BuildContext context, WidgetRef ref, RouteModel routeState) {
    final tokensEarned = (routeState.distance / 5).floor(); // 1 токен за 5 км
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Distance Traveled: ${routeState.distance.toStringAsFixed(2)} NM\n'
            'Tokens Earned: $tokensEarned SCAI',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await ref.read(routeProvider.notifier).endRoute();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Route Ended',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            'Route ended. Please note:',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'After the Verification of your Ship position and Confirmation of the distance covered by our tech Manager,'
                            'You will receive the earned SCAI tokens in your account (within 48 hours)',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 33, 143, 36)),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('End Route'),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressRoute() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Route in Progress',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ],
    );
  }

  Widget _buildStartRouteButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () async {
        await _checkLocationPermission(context, ref);
      },
      child: const Text('Start Route'),
    );
  }

  Future<void> _checkLocationPermission(
      BuildContext context, WidgetRef ref) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Location permission denied.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
                'Location permission permanently denied. Open settings to grant permission.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  Geolocator.openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    await ref.read(routeProvider.notifier).startRoute();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Route Started',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Route started. Please note:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Using VPN during route tracking is strictly prohibited. '
                  'If a VPN is detected while tracking your location, any accumulated SCAI tokens for this route may be annulled.',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

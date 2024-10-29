import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../application/route_notifier.dart';
import '../domain/route_model.dart';

class RouteTrackingScreen extends ConsumerWidget {
  const RouteTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(routeProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Route Tracking'),
      //   backgroundColor: Colors.black87,
      // ),
      body: FutureBuilder<Position>(
        future: ref.read(routeProvider.notifier).getCurrentPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final currentPosition = snapshot.data;

          return Column(
            children: [
              // Карта
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: FlutterMap(
                  options: MapOptions(
                    crs: const Epsg3857(),
                    initialCenter: currentPosition != null
                        ? LatLng(
                            currentPosition.latitude, currentPosition.longitude)
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
              ),
              _buildDistanceInfo(routeState),
              Center(
                child: routeState.start != null && routeState.end == null
                    ? _buildInProgressRoute(context, ref, routeState)
                    : _buildStartRouteButton(context, ref),
              ),
              // Кнопки для зума
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: () {
                      ref.read(routeProvider.notifier).zoomIn();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: () {
                      ref.read(routeProvider.notifier).zoomOut();
                    },
                  ),
                ],
              ),
            ],
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

  Widget _buildInProgressRoute(
      BuildContext context, WidgetRef ref, RouteModel routeState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Route in Progress', style: TextStyle(fontSize: 20)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () async {
            await ref.read(routeProvider.notifier).endRoute();
            final tokensEarned =
                (routeState.distance / 5).floor().toString(); // 1 токен за 5 км
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Route completed, tokens earned: $tokensEarned SCT'),
              ),
            );
          },
          child: const Text('End Route'),
        ),
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

  Widget _buildDistanceInfo(RouteModel routeState) {
    final tokensEarned = (routeState.distance / 5).floor(); // 1 токен за 5 км
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Distance Traveled: ${routeState.distance.toStringAsFixed(2)} km\n'
        'Tokens Earned: $tokensEarned SCT',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _checkLocationPermission(
      BuildContext context, WidgetRef ref) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission permanently denied.')),
      );
      await Geolocator.openAppSettings();
      return;
    }

    await ref.read(routeProvider.notifier).startRoute();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route started')),
    );
  }
}

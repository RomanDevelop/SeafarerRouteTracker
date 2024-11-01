// Other imports...
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Route Tracking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Position>(
        future: ref.read(routeProvider.notifier).getCurrentPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final currentPosition = snapshot.data;

          return Stack(
            children: [
              FlutterMap(
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildDistanceInfo(context, ref, routeState),
              ),
              Center(
                child: routeState.start != null && routeState.end == null
                    ? _buildInProgressRoute(context, ref, routeState)
                    : _buildStartRouteButton(context, ref),
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
        child: Icon(Icons.circle, color: Colors.green, size: 40),
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
            'Distance Traveled: ${routeState.distance.toStringAsFixed(2)} km\n'
            'Tokens Earned: $tokensEarned SCT',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Обработчик для кнопки завершения маршрута
              await ref.read(routeProvider.notifier).endRoute();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Route ended')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('End Route'),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressRoute(
      BuildContext context, WidgetRef ref, RouteModel routeState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Route in Progress',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission permanently denied.')),
      );
      await Geolocator.openAppSettings();
      return;
    }

    await ref.read(routeProvider.notifier).startRoute();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route started')),
    );
  }
}

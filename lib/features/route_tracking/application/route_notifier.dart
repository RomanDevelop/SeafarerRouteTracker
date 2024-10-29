import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/route_model.dart';

class RouteNotifier extends StateNotifier<RouteModel> {
  RouteNotifier() : super(RouteModel());

  double _currentZoom = 13.0; // Начальный уровень масштабирования

  Future<void> startRoute() async {
    Position position = await _getCurrentPosition();
    state = state.copyWith(start: position, distance: 0);
  }

  Future<void> endRoute() async {
    Position position = await _getCurrentPosition();
    state = state.copyWith(end: position);

    if (state.start != null) {
      double distance = calculateDistance(state.start!, position);
      state = state.copyWith(distance: distance);
    }
  }

  double calculateDistance(Position start, Position end) {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000;
  }

  Future<Position> getCurrentPosition() async {
    return await _getCurrentPosition();
  }

  Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Метод для увеличения масштаба
  void zoomIn() {
    if (_currentZoom < 18.0) {
      // Ограничиваем максимальный уровень зума
      _currentZoom += 1.0;
      state = state.copyWith(zoomLevel: _currentZoom);
    }
  }

  // Метод для уменьшения масштаба
  void zoomOut() {
    if (_currentZoom > 5.0) {
      // Ограничиваем минимальный уровень зума
      _currentZoom -= 1.0;
      state = state.copyWith(zoomLevel: _currentZoom);
    }
  }
}

// Провайдер для RouteNotifier
final routeProvider = StateNotifierProvider<RouteNotifier, RouteModel>((ref) {
  return RouteNotifier();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/route_model.dart';

class RouteNotifier extends StateNotifier<RouteModel> {
  RouteNotifier() : super(RouteModel());

  double _currentZoom = 13.0; // Начальный уровень масштабирования

  // Метод для начала маршрута
  Future<void> startRoute() async {
    Position position = await _getCurrentPosition();
    state = state.copyWith(start: position, distance: 0);
  }

  // Метод для завершения маршрута
  Future<void> endRoute() async {
    Position position = await _getCurrentPosition();
    state = state.copyWith(end: position);

    if (state.start != null) {
      double distance = calculateDistance(state.start!, position);
      state = state.copyWith(distance: distance);
    }
  }

  // Метод для расчета расстояния между двумя точками
  double calculateDistance(Position start, Position end) {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000; // Преобразование в километры
  }

  // Метод для получения текущей позиции
  Future<Position> getCurrentPosition() async {
    return await _getCurrentPosition();
  }

  // Метод для получения текущей позиции с проверкой разрешений
  Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    // Запрос разрешений на получение местоположения
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

  // Метод для увеличения масштаба карты
  void zoomIn() {
    if (_currentZoom < 18.0) {
      _currentZoom += 1.0; // Увеличение на 1
      state = state.copyWith(zoomLevel: _currentZoom);
    }
  }

  // Метод для уменьшения масштаба карты
  void zoomOut() {
    if (_currentZoom > 5.0) {
      _currentZoom -= 1.0; // Уменьшение на 1
      state = state.copyWith(zoomLevel: _currentZoom);
    }
  }
}

// Провайдер для RouteNotifier
final routeProvider = StateNotifierProvider<RouteNotifier, RouteModel>((ref) {
  return RouteNotifier();
});

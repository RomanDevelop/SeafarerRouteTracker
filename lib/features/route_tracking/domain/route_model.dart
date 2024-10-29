import 'package:geolocator/geolocator.dart';

class RouteModel {
  final Position? start;
  final Position? end;
  final double distance;
  final double zoomLevel; // Добавлено поле для уровня масштабирования

  RouteModel({
    this.start,
    this.end,
    this.distance = 0,
    this.zoomLevel = 13.0, // Установите начальный уровень масштабирования
  });

  RouteModel copyWith({
    Position? start,
    Position? end,
    double? distance,
    double? zoomLevel,
  }) {
    return RouteModel(
      start: start ?? this.start,
      end: end ?? this.end,
      distance: distance ?? this.distance,
      zoomLevel: zoomLevel ?? this.zoomLevel,
    );
  }
}

import 'package:geolocator/geolocator.dart';

class RouteRepository {
  Position? _currentStartPosition;

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void setStartPosition(Position position) {
    _currentStartPosition = position;
  }

  Position? getStartPosition() {
    return _currentStartPosition;
  }

  double calculateDistance(Position start, Position end) {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000; // Перевод в километры
  }
}

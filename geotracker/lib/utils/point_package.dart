import 'package:latlong2/latlong.dart';

class PointPackage {
  final LatLng? _point;
  final String _name;

  PointPackage(this._point, this._name);

  String get name => _name;

  LatLng? get point => _point;
}
import 'package:freeletics_running/models/element_distance.dart';

class DistanceMatrix{
  DistanceMatrix({this.distance,this.duration});
  final ElementDistance distance;
  final ElementDistance duration;
  @override
  String toString() {
    return 'DistanceMatrix(distance: $distance, duration: $duration)';
  }

}
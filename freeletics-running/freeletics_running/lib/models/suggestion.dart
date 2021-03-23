import 'package:equatable/equatable.dart';

class Suggestion extends Equatable{
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
  Suggestion.fromJson(Map<String, dynamic> json)
      : placeId = json['placeId'],
        description = json['description']
        ;

  Map<String, dynamic> toJson() => {
    'placeId': placeId,
    'description': description,

  };

  @override
  // TODO: implement props
  List<Object> get props => [placeId,description];
}
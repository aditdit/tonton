import 'package:equatable/equatable.dart';

class Season extends Equatable {
  Season({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.episodeCount,
    required this.airDate,
    required this.overview,
  });

  final int id;
  final String name;
  final String posterPath;
  final int episodeCount;
  final String airDate;
  final String overview;

  @override
  List<Object> get props => [
        id,
        name,
        posterPath,
        episodeCount,
        airDate,
        overview,
      ];
}

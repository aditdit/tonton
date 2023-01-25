import 'package:core/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class SeasonModel extends Equatable {
  const SeasonModel({
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

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        id: json["id"],
        name: json["name"],
        posterPath: json["poster_path"] ?? "",
        episodeCount: json["episode_count"],
        airDate: json["air_date"] ?? "",
        overview: json["overview"],
      );

  Season toEntity() {
    return Season(
      id: id,
      name: name,
      posterPath: posterPath,
      episodeCount: episodeCount,
      airDate: airDate,
      overview: overview,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        posterPath,
        episodeCount,
        airDate,
        overview,
      ];
}

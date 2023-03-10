import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class MovieDetail extends Equatable {
  const MovieDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final int runtime;
  final String title;
  final double voteAverage;
  final int voteCount;
  final List<Season> seasons;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        originalTitle,
        overview,
        posterPath,
        releaseDate,
        title,
        voteAverage,
        voteCount,
        seasons,
      ];

  static const empty = MovieDetail(
    adult: false,
    backdropPath: "",
    genres: <Genre>[],
    id: 0,
    originalTitle: "",
    overview: "",
    posterPath: "",
    releaseDate: "",
    runtime: 0,
    title: "",
    voteAverage: 0,
    voteCount: 0,
    seasons: <Season>[],
  );
}

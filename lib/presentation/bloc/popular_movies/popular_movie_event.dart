part of 'popular_movie_bloc.dart';

abstract class PopularMovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PopularMovieFetched extends PopularMovieEvent {
  final bool isMovie;

  PopularMovieFetched(this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

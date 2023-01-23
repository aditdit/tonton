part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PopularMovieFetched extends TopRatedMovieEvent {
  final bool isMovie;

  PopularMovieFetched(this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TopRatedMovieFetched extends TopRatedMovieEvent {
  final bool isMovie;

  TopRatedMovieFetched(this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NowPlayingMovieListFetched extends MovieListEvent {
  final bool isMovie;

  NowPlayingMovieListFetched(this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

class TopRatedMovieListFetched extends MovieListEvent {
  final bool isMovie;

  TopRatedMovieListFetched(this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

class PopularMovieListFetched extends MovieListEvent {
  final bool isMovie;

  PopularMovieListFetched(this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

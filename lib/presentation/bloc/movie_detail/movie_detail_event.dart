part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieDetailFetched extends MovieDetailEvent {
  final int id;
  final bool isMovie;

  MovieDetailFetched(this.id, this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

class WatchlistStatusLoaded extends MovieDetailEvent {
  final int id;

  WatchlistStatusLoaded(this.id);

  @override
  List<Object> get props => [id];
}

class WatchlistAdded extends MovieDetailEvent {
  final MovieDetail movie;

  WatchlistAdded(this.movie);

  @override
  List<Object> get props => [movie];
}

class WatchlistRemoved extends MovieDetailEvent {
  final MovieDetail movie;

  WatchlistRemoved(this.movie);

  @override
  List<Object> get props => [movie];
}

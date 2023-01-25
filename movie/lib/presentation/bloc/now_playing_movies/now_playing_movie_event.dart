part of 'now_playing_movie_bloc.dart';

abstract class NowPlayingMovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NowPlayingMovieFetched extends NowPlayingMovieEvent {
  final bool isMovie;

  NowPlayingMovieFetched(this.isMovie);

  @override
  List<Object> get props => [isMovie];
}

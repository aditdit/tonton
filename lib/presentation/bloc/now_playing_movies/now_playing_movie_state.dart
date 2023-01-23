part of 'now_playing_movie_bloc.dart';

class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState({
    this.state = RequestState.Empty,
    this.movies = const <Movie>[],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  NowPlayingMovieState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return NowPlayingMovieState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}

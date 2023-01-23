part of 'watchlist_movie_bloc.dart';

class WatchlistMovieState extends Equatable {
  const WatchlistMovieState({
    this.state = RequestState.Empty,
    this.movies = const <Movie>[],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  WatchlistMovieState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return WatchlistMovieState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}

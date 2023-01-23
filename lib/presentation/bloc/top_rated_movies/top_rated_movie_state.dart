part of 'top_rated_movie_bloc.dart';

class TopRatedMovieState extends Equatable {
  const TopRatedMovieState({
    this.state = RequestState.Empty,
    this.movies = const <Movie>[],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  TopRatedMovieState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return TopRatedMovieState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}

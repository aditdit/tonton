part of 'popular_movie_bloc.dart';

class PopularMovieState extends Equatable {
  const PopularMovieState({
    this.state = RequestState.Empty,
    this.movies = const <Movie>[],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  PopularMovieState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMovieState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}

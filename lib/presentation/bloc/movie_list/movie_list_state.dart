part of 'movie_list_bloc.dart';

class MovieState extends Equatable {
  const MovieState({
    this.state = RequestState.Empty,
    this.movies = const <Movie>[],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  MovieState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return MovieState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}

class MovieListState extends Equatable {
  const MovieListState({
    this.nowPlayingMovieList = const MovieState(),
    this.topRatedMovieList = const MovieState(),
    this.popularMovieList = const MovieState(),
  });

  final MovieState nowPlayingMovieList;
  final MovieState topRatedMovieList;
  final MovieState popularMovieList;

  MovieListState copyWith({
    MovieState? nowPlayingMovieList,
    MovieState? topRatedMovieList,
    MovieState? popularMovieList,
  }) {
    return MovieListState(
      nowPlayingMovieList: nowPlayingMovieList ?? this.nowPlayingMovieList,
      topRatedMovieList: topRatedMovieList ?? this.topRatedMovieList,
      popularMovieList: popularMovieList ?? this.popularMovieList,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingMovieList,
        topRatedMovieList,
        popularMovieList,
      ];
}

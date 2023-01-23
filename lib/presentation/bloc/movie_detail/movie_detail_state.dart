part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.state = RequestState.Empty,
    this.stateRecommendations = RequestState.Empty,
    this.movie = MovieDetail.empty,
    this.movieRecommendations = const <Movie>[],
    this.isAddedtoWatchlist = false,
    this.message = "",
  });

  final RequestState state;
  final RequestState stateRecommendations;
  final MovieDetail movie;
  final List<Movie> movieRecommendations;
  final bool isAddedtoWatchlist;
  final String message;

  MovieDetailState copyWith({
    RequestState? state,
    RequestState? stateRecommendations,
    MovieDetail? movie,
    List<Movie>? movieRecommendations,
    bool? isAddedtoWatchlist,
    String? message,
  }) {
    return MovieDetailState(
      state: state ?? this.state,
      stateRecommendations: stateRecommendations ?? this.stateRecommendations,
      movie: movie ?? this.movie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isAddedtoWatchlist: isAddedtoWatchlist ?? this.isAddedtoWatchlist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        state,
        stateRecommendations,
        movie,
        movieRecommendations,
        isAddedtoWatchlist,
        message,
      ];
}

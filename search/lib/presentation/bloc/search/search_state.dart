part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.state = RequestState.Empty,
    this.movies = const <Movie>[],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  SearchState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return SearchState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}

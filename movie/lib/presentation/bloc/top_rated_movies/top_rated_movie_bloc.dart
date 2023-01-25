import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies)
      : super(const TopRatedMovieState()) {
    on<TopRatedMovieFetched>(
      (event, emit) async {
        await _topRatedFetched(emit, event);
      },
    );
  }

  Future<void> _topRatedFetched(
    Emitter<TopRatedMovieState> emit,
    TopRatedMovieFetched event,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await _getTopRatedMovies.execute(event.isMovie);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            state: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            state: RequestState.Loaded,
            movies: data,
          ),
        );
      },
    );
  }
}

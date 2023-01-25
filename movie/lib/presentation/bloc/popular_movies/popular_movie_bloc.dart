import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(this._getPopularMovies) : super(const PopularMovieState()) {
    on<PopularMovieFetched>(
      (event, emit) async {
        await _popularMovieFetched(emit, event);
      },
    );
  }

  Future<void> _popularMovieFetched(
    Emitter<PopularMovieState> emit,
    PopularMovieFetched event,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await _getPopularMovies.execute(event.isMovie);

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

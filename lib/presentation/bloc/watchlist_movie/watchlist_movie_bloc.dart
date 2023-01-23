import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMovieBloc(this._getWatchlistMovies) : super(WatchlistMovieState()) {
    on<WatchlistMovieFetched>(
      (event, emit) async {
        await _watchlistMovieFetched(emit, event);
      },
    );
  }

  Future<void> _watchlistMovieFetched(
    Emitter<WatchlistMovieState> emit,
    WatchlistMovieFetched event,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await _getWatchlistMovies.execute();

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

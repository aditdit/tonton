import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieDetailBloc(
    this._getMovieDetail,
    this._getMovieRecommendations,
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(MovieDetailState()) {
    on<MovieDetailFetched>(
      (event, emit) async {
        await _movieDetailFetched(emit, event);
      },
    );

    on<WatchlistStatusLoaded>(
      (event, emit) async {
        await _watchlistStatusLoaded(emit, event);
      },
    );

    on<WatchlistAdded>(
      (event, emit) async {
        await _watchlistAdded(emit, event);
      },
    );

    on<WatchlistRemoved>(
      (event, emit) async {
        await _watchlistRemoved(emit, event);
      },
    );
  }

  Future<void> _movieDetailFetched(
    Emitter<MovieDetailState> emit,
    MovieDetailFetched event,
  ) async {
    emit(state.copyWith(state: RequestState.Loading, message: ""));
    final result = await _getMovieDetail.execute(event.id, event.isMovie);
    final recommendationResult =
        await _getMovieRecommendations.execute(event.id, event.isMovie);

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
        recommendationResult.fold(
          (failure) {
            emit(
              state.copyWith(
                state: RequestState.Loaded,
                stateRecommendations: RequestState.Error,
                movie: data,
                message: failure.message,
              ),
            );
          },
          (movies) {
            emit(
              state.copyWith(
                state: RequestState.Loaded,
                stateRecommendations: RequestState.Loaded,
                movie: data,
                movieRecommendations: movies,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _watchlistStatusLoaded(
    Emitter<MovieDetailState> emit,
    WatchlistStatusLoaded event,
  ) async {
    final result = await _getWatchListStatus.execute(event.id);
    emit(
      state.copyWith(isAddedtoWatchlist: result),
    );
  }

  Future<void> _watchlistAdded(
    Emitter<MovieDetailState> emit,
    WatchlistAdded event,
  ) async {
    final result = await _saveWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            message: failure.message,
            isAddedtoWatchlist: false,
          ),
        );
      },
      (successMessage) async {
        emit(
          state.copyWith(
            message: successMessage,
            isAddedtoWatchlist: true,
          ),
        );
      },
    );
  }

  Future<void> _watchlistRemoved(
    Emitter<MovieDetailState> emit,
    WatchlistRemoved event,
  ) async {
    final result = await _removeWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            message: failure.message,
            isAddedtoWatchlist: true,
          ),
        );
      },
      (successMessage) async {
        emit(
          state.copyWith(
            message: successMessage,
            isAddedtoWatchlist: false,
          ),
        );
      },
    );
  }
}

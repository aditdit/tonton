import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetTopRatedMovies _getTopRatedMovies;
  final GetPopularMovies _getPopularMovies;

  MovieListBloc(
    this._getNowPlayingMovies,
    this._getTopRatedMovies,
    this._getPopularMovies,
  ) : super(const MovieListState()) {
    on<NowPlayingMovieListFetched>(
      (event, emit) async {
        await _nowPlayingMovieListFetched(emit, event);
      },
    );

    on<TopRatedMovieListFetched>(
      (event, emit) async {
        await _topRatedMovieListFetched(emit, event);
      },
    );

    on<PopularMovieListFetched>(
      (event, emit) async {
        await _popularMovieListFetched(emit, event);
      },
    );
  }

  Future<void> _nowPlayingMovieListFetched(
    Emitter<MovieListState> emit,
    NowPlayingMovieListFetched event,
  ) async {
    emit(state.copyWith(
      nowPlayingMovieList: const MovieState(state: RequestState.Loading),
    ));
    final result = await _getNowPlayingMovies.execute(event.isMovie);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            nowPlayingMovieList: MovieState(
              state: RequestState.Error,
              message: failure.message,
            ),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            nowPlayingMovieList: MovieState(
              state: RequestState.Loaded,
              movies: data,
            ),
          ),
        );
      },
    );
  }

  Future<void> _topRatedMovieListFetched(
    Emitter<MovieListState> emit,
    TopRatedMovieListFetched event,
  ) async {
    emit(state.copyWith(
      topRatedMovieList: const MovieState(state: RequestState.Loading),
    ));
    final result = await _getTopRatedMovies.execute(event.isMovie);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            topRatedMovieList: MovieState(
              state: RequestState.Error,
              message: failure.message,
            ),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            topRatedMovieList: MovieState(
              state: RequestState.Loaded,
              movies: data,
            ),
          ),
        );
      },
    );
  }

  Future<void> _popularMovieListFetched(
    Emitter<MovieListState> emit,
    PopularMovieListFetched event,
  ) async {
    emit(state.copyWith(
      popularMovieList: const MovieState(state: RequestState.Loading),
    ));
    final result = await _getPopularMovies.execute(event.isMovie);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            popularMovieList: MovieState(
              state: RequestState.Error,
              message: failure.message,
            ),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            popularMovieList: MovieState(
              state: RequestState.Loaded,
              movies: data,
            ),
          ),
        );
      },
    );
  }
}

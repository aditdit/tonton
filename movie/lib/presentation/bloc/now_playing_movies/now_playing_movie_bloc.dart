import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie.dart';

part 'now_playing_movie_event.dart';
part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMovieBloc(this._getNowPlayingMovies)
      : super(const NowPlayingMovieState()) {
    on<NowPlayingMovieFetched>(
      (event, emit) async {
        await _nowPlayingMovieFetched(emit, event);
      },
    );
  }

  Future<void> _nowPlayingMovieFetched(
    Emitter<NowPlayingMovieState> emit,
    NowPlayingMovieFetched event,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await _getNowPlayingMovies.execute(event.isMovie);

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

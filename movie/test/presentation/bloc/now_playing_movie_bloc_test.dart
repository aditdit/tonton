import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMovieBloc nowPlayingMovieBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMovieBloc = NowPlayingMovieBloc(mockGetNowPlayingMovies);
  });

  test("initial test should be empty", () {
    expect(nowPlayingMovieBloc.state, const NowPlayingMovieState());
  });

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'sould emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute(true))
          .thenAnswer((_) async => Right(testMovieList));

      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMovieFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const NowPlayingMovieState(state: RequestState.Loading),
      NowPlayingMovieState(state: RequestState.Loaded, movies: testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute(true));
    },
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute(true))
          .thenAnswer((_) async => Left(ServerFailure('Server failure')));

      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(NowPlayingMovieFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const NowPlayingMovieState(state: RequestState.Loading),
      const NowPlayingMovieState(
          state: RequestState.Error, message: 'Server failure'),
    ],
    verify: (block) {
      verify(mockGetNowPlayingMovies.execute(true));
    },
  );
}

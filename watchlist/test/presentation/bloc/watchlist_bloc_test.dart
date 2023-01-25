import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';
import 'package:watchlist/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_bloc_test.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  test("initial test should be empty", () {
    expect(watchlistMovieBloc.state, const WatchlistMovieState());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'sould emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));

      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovieFetched()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieState(state: RequestState.Loading),
      WatchlistMovieState(state: RequestState.Loaded, movies: testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));

      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovieFetched()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieState(state: RequestState.Loading),
      const WatchlistMovieState(
          state: RequestState.Error, message: "Can't get data"),
    ],
    verify: (block) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}

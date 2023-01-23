import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchlistStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  test("initial test should be empty", () {
    expect(movieDetailBloc.state, MovieDetailState());
  });

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'sould emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId, true))
            .thenAnswer((_) async => Right(testMovieDetail));

        when(mockGetMovieRecommendations.execute(tId, true))
            .thenAnswer((_) async => Right(testMovieList));

        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(MovieDetailFetched(tId, true)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailState(state: RequestState.Loading),
        MovieDetailState(
          state: RequestState.Loaded,
          stateRecommendations: RequestState.Loaded,
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId, true));
        verify(mockGetMovieRecommendations.execute(tId, true));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId, true))
            .thenAnswer((_) async => Left(ServerFailure('Server failure')));

        when(mockGetMovieRecommendations.execute(tId, true))
            .thenAnswer((_) async => Left(ServerFailure('Server failure')));

        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(MovieDetailFetched(tId, true)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailState(state: RequestState.Loading),
        MovieDetailState(state: RequestState.Error, message: 'Server failure'),
      ],
      verify: (block) {
        verify(mockGetMovieDetail.execute(tId, true));
        verify(mockGetMovieRecommendations.execute(tId, true));
      },
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);

        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(WatchlistStatusLoaded(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailState(isAddedtoWatchlist: true),
      ],
      verify: (block) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success'));

        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(WatchlistAdded(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailState(
          isAddedtoWatchlist: true,
          message: 'Success',
        ),
      ],
      verify: (block) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));

        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(WatchlistAdded(testMovieDetail)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        MovieDetailState(
          isAddedtoWatchlist: false,
          message: 'Failed',
        ),
      ],
      verify: (block) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));

        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(WatchlistRemoved(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailState(
          isAddedtoWatchlist: false,
          message: 'Removed',
        ),
      ],
      verify: (block) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );
  });
}

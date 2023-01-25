import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      mockGetNowPlayingMovies,
      mockGetTopRatedMovies,
      mockGetPopularMovies,
    );
  });

  test("initial test should be empty", () {
    expect(movieListBloc.state, const MovieListState());
  });

  blocTest<MovieListBloc, MovieListState>(
    'sould emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute(true))
          .thenAnswer((_) async => Right(testMovieList));

      when(mockGetTopRatedMovies.execute(true))
          .thenAnswer((_) async => Right(testMovieList));

      when(mockGetPopularMovies.execute(true))
          .thenAnswer((_) async => Right(testMovieList));

      return movieListBloc;
    },
    act: (bloc) => bloc
      ..add(NowPlayingMovieListFetched(true))
      ..add(TopRatedMovieListFetched(true))
      ..add(PopularMovieListFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const MovieListState(
        nowPlayingMovieList: MovieState(state: RequestState.Loading),
      ),
      MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
      ),
      MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
        topRatedMovieList: const MovieState(state: RequestState.Loading),
      ),
      MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
        topRatedMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
      ),
      MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
        topRatedMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
        popularMovieList: const MovieState(state: RequestState.Loading),
      ),
      MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
        topRatedMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
        popularMovieList:
            MovieState(state: RequestState.Loaded, movies: testMovieList),
      ),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute(true));
      verify(mockGetTopRatedMovies.execute(true));
      verify(mockGetPopularMovies.execute(true));
    },
  );

  blocTest<MovieListBloc, MovieListState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute(true))
          .thenAnswer((_) async => Left(ServerFailure('Server failure')));

      when(mockGetTopRatedMovies.execute(true))
          .thenAnswer((_) async => Left(ServerFailure('Server failure')));

      when(mockGetPopularMovies.execute(true))
          .thenAnswer((_) async => Left(ServerFailure('Server failure')));

      return movieListBloc;
    },
    act: (bloc) => bloc
      ..add(NowPlayingMovieListFetched(true))
      ..add(TopRatedMovieListFetched(true))
      ..add(PopularMovieListFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const MovieListState(
        nowPlayingMovieList: MovieState(state: RequestState.Loading),
      ),
      const MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
      ),
      const MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
        topRatedMovieList: MovieState(state: RequestState.Loading),
      ),
      const MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
        topRatedMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
      ),
      const MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
        topRatedMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
        popularMovieList: MovieState(state: RequestState.Loading),
      ),
      const MovieListState(
        nowPlayingMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
        topRatedMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
        popularMovieList:
            MovieState(state: RequestState.Error, message: 'Server failure'),
      ),
    ],
    verify: (block) {
      verify(mockGetNowPlayingMovies.execute(true));
      verify(mockGetTopRatedMovies.execute(true));
      verify(mockGetPopularMovies.execute(true));
    },
  );
}

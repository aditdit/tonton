import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMovieBloc popularMovieBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovies);
  });

  test("initial test should be empty", () {
    expect(popularMovieBloc.state, PopularMovieState());
  });

  blocTest<PopularMovieBloc, PopularMovieState>(
    'sould emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute(true))
          .thenAnswer((_) async => Right(testMovieList));

      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(PopularMovieFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularMovieState(state: RequestState.Loading),
      PopularMovieState(state: RequestState.Loaded, movies: testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute(true));
    },
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute(true))
          .thenAnswer((_) async => Left(ServerFailure('Server failure')));

      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(PopularMovieFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularMovieState(state: RequestState.Loading),
      PopularMovieState(state: RequestState.Error, message: 'Server failure'),
    ],
    verify: (block) {
      verify(mockGetPopularMovies.execute(true));
    },
  );
}

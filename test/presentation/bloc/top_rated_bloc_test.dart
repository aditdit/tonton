import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMovieBloc topRatedBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedBloc = TopRatedMovieBloc(mockGetTopRatedMovies);
  });

  test("initial test should be empty", () {
    expect(topRatedBloc.state, TopRatedMovieState());
  });

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'sould emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute(true))
          .thenAnswer((_) async => Right(testMovieList));

      return topRatedBloc;
    },
    act: (bloc) => bloc.add(PopularMovieFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieState(state: RequestState.Loading),
      TopRatedMovieState(state: RequestState.Loaded, movies: testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute(true));
    },
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute(true))
          .thenAnswer((_) async => Left(ServerFailure('Server failure')));

      return topRatedBloc;
    },
    act: (bloc) => bloc.add(PopularMovieFetched(true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieState(state: RequestState.Loading),
      TopRatedMovieState(state: RequestState.Error, message: 'Server failure'),
    ],
    verify: (block) {
      verify(mockGetTopRatedMovies.execute(true));
    },
  );
}

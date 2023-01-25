import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/presentation/bloc/search/search_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = SearchBloc(mockSearchMovies);
  });

  test("initial test should be empty", () {
    expect(searchBloc.state, const SearchState());
  });

  blocTest<SearchBloc, SearchState>(
    'sould emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery, true))
          .thenAnswer((_) async => Right(testMovieList));

      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery, true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const SearchState(state: RequestState.Loading),
      SearchState(state: RequestState.Loaded, movies: testMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery, true));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery, true))
          .thenAnswer((_) async => Left(ServerFailure('Server failure')));

      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery, true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const SearchState(state: RequestState.Loading),
      const SearchState(state: RequestState.Error, message: 'Server failure'),
    ],
    verify: (block) {
      verify(mockSearchMovies.execute(tQuery, true));
    },
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
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
    expect(searchBloc.state, SearchState());
  });

  blocTest<SearchBloc, SearchState>(
    'sould emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery, true))
          .thenAnswer((_) async => Right(testMovieList));

      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery, true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchState(state: RequestState.Loading),
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
    act: (bloc) => bloc.add(OnQueryChanged(tQuery, true)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchState(state: RequestState.Loading),
      SearchState(state: RequestState.Error, message: 'Server failure'),
    ],
    verify: (block) {
      verify(mockSearchMovies.execute(tQuery, true));
    },
  );
}

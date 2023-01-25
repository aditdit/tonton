import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../core/test/helpers/test_helper.mocks.dart';
import '../../../core/test/dummy_data/dummy_objects.dart';

void main() {
  late GetMovieDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetail(mockMovieRepository);
  });

  const tId = 1;

  test('should get movie detail from the repository', () async {
    // arrange
    when(mockMovieRepository.getMovieDetail(tId, true))
        .thenAnswer((_) async => Right(testMovieDetail));
    // act
    final result = await usecase.execute(tId, true);
    // assert
    expect(result, Right(testMovieDetail));
  });

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockMovieRepository.getMovieDetail(tId, false))
        .thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(tId, false);
    // assert
    expect(result, Right(testTvDetail));
  });
}

import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/failure.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies(bool isMovie);
  Future<Either<Failure, List<Movie>>> getPopularMovies(bool isMovie);
  Future<Either<Failure, List<Movie>>> getTopRatedMovies(bool isMovie);
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id, bool isMovie);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(
      int id, bool isMovie);
  Future<Either<Failure, List<Movie>>> searchMovies(String query, bool isMovie);
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistMovies();
}

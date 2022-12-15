import 'dart:convert';

import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies(bool isMovie);
  Future<List<MovieModel>> getPopularMovies(bool isMovie);
  Future<List<MovieModel>> getTopRatedMovies(bool isMovie);
  Future<MovieDetailResponse> getMovieDetail(int id, bool isMovie);
  Future<List<MovieModel>> getMovieRecommendations(int id, bool isMovie);
  Future<List<MovieModel>> searchMovies(String query, bool isMovie);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies(bool isMovie) async {
    final path = isMovie ? "now_playing" : "on_the_air";
    final response = await client
        .get(Uri.parse('$BASE_URL/${getCategory(isMovie)}/$path?$API_KEY'));

    try {
      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id, bool isMovie) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/${getCategory(isMovie)}/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id, bool isMovie) async {
    final response = await client.get(Uri.parse(
        '$BASE_URL/${getCategory(isMovie)}/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies(bool isMovie) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/${getCategory(isMovie)}/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies(bool isMovie) async {
    final category = isMovie ? "movie" : "tv";

    final response = await client
        .get(Uri.parse('$BASE_URL/${getCategory(isMovie)}/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, bool isMovie) async {
    final response = await client.get(Uri.parse(
        '$BASE_URL/search/${getCategory(isMovie)}?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  String getCategory(bool isMovie) {
    return isMovie ? "movie" : "tv";
  }
}

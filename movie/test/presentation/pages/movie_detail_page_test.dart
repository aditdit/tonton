import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>(
      create: (context) => movieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(
      const MovieDetailState(
        state: RequestState.Loaded,
        stateRecommendations: RequestState.Loaded,
        movie: MovieDetail.empty,
        movieRecommendations: [],
        isAddedtoWatchlist: false,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
      isMovie: true,
    )));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(
      const MovieDetailState(
        state: RequestState.Loaded,
        stateRecommendations: RequestState.Loaded,
        movie: MovieDetail.empty,
        movieRecommendations: [],
        isAddedtoWatchlist: true,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
      isMovie: true,
    )));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}

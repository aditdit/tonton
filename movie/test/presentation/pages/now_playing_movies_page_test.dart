import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movie_bloc.dart';
import 'package:movie/presentation/pages/now_playing_movies_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNowPlayingMovieBloc
    extends MockBloc<NowPlayingMovieEvent, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

void main() {
  late NowPlayingMovieBloc nowPlayingMovieBloc;

  setUp(() {
    nowPlayingMovieBloc = MockNowPlayingMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingMovieBloc>(
      create: (context) => nowPlayingMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => nowPlayingMovieBloc.state).thenReturn(
      const NowPlayingMovieState(state: RequestState.Loading),
    );

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const NowPlayingMoviesPage(
      isMovie: true,
    )));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => nowPlayingMovieBloc.state).thenReturn(
      const NowPlayingMovieState(state: RequestState.Loaded, movies: []),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const NowPlayingMoviesPage(
      isMovie: true,
    )));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => nowPlayingMovieBloc.state).thenReturn(
      const NowPlayingMovieState(
          state: RequestState.Error, message: 'Error message'),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const NowPlayingMoviesPage(
      isMovie: true,
    )));

    expect(textFinder, findsOneWidget);
  });
}

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/now_playing_movies_page.dart';
import 'package:ditonton/presentation/provider/now_playing_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'now_playing_movies_page_test.mocks.dart';

@GenerateMocks([NowPlayingMoviesNotifier])
void main() {
  late MockNowPlayingMoviesNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockNowPlayingMoviesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<NowPlayingMoviesNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage(
      isMovie: true,
    )));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.movies).thenReturn(<Movie>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage(
      isMovie: true,
    )));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage(
      isMovie: true,
    )));

    expect(textFinder, findsOneWidget);
  });
}

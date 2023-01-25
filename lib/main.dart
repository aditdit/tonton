import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/search.dart';
import 'package:watchlist/watchlist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case NOW_PLAYING_MOVIE_ROUTE:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingMoviesPage(isMovie: isMovie));
            case POPULAR_MOVIES_ROUTE:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => PopularMoviesPage(isMovie: isMovie));
            case TOP_RATED_ROUTE:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => TopRatedMoviesPage(isMovie: isMovie));
            case MOVIE_DETAIL_ROUTE:
              final args = settings.arguments as Map;
              final id = args["id"];
              final isMovie = args["isMovie"];
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id, isMovie: isMovie),
                settings: settings,
              );
            case SEARCH_ROUTE:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => SearchPage(isMovie: isMovie));
            case WATCHLIST_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

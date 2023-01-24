import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_movies/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/now_playing_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

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
            case NowPlayingMoviesPage.ROUTE_NAME:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingMoviesPage(isMovie: isMovie));
            case PopularMoviesPage.ROUTE_NAME:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => PopularMoviesPage(isMovie: isMovie));
            case TopRatedMoviesPage.ROUTE_NAME:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => TopRatedMoviesPage(isMovie: isMovie));
            case MovieDetailPage.ROUTE_NAME:
              final args = settings.arguments as Map;
              final id = args["id"];
              final isMovie = args["isMovie"];
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id, isMovie: isMovie),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                  builder: (_) => SearchPage(isMovie: isMovie));
            case WatchlistMoviesPage.ROUTE_NAME:
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

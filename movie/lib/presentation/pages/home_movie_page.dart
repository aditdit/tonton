import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/search.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  var isMovie = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    initData();
  }

  void initData() {
    Future.microtask(() => context.read<MovieListBloc>()
      ..add(NowPlayingMovieListFetched(isMovie))
      ..add(TopRatedMovieListFetched(isMovie))
      ..add(PopularMovieListFetched(isMovie)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                setState(() {
                  isMovie = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Tv Series'),
              onTap: () {
                setState(() {
                  isMovie = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_MOVIES_ROUTE);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SearchBloc>().add(InitEvent());
              Navigator.pushNamed(
                context,
                SEARCH_ROUTE,
                arguments: isMovie,
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (isMovie
                  ? Text(
                      'Now Playing',
                      style: kHeading6,
                    )
                  : _buildSubHeading(
                      title: 'On The Air',
                      onTap: () => Navigator.pushNamed(
                        context,
                        NOW_PLAYING_MOVIE_ROUTE,
                        arguments: isMovie,
                      ),
                    )),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  if (state.nowPlayingMovieList.state == RequestState.Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.nowPlayingMovieList.state ==
                      RequestState.Loaded) {
                    return MovieList(state.nowPlayingMovieList.movies, isMovie);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(
                  context,
                  POPULAR_MOVIES_ROUTE,
                  arguments: isMovie,
                ),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                  builder: (context, state) {
                if (state.popularMovieList.state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.popularMovieList.state ==
                    RequestState.Loaded) {
                  return MovieList(state.popularMovieList.movies, isMovie);
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TOP_RATED_ROUTE,
                  arguments: isMovie,
                ),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                  builder: (context, state) {
                if (state.topRatedMovieList.state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.topRatedMovieList.state ==
                    RequestState.Loaded) {
                  return MovieList(state.topRatedMovieList.movies, isMovie);
                } else {
                  return const Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final bool isMovie;

  const MovieList(this.movies, this.isMovie);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MOVIE_DETAIL_ROUTE,
                  arguments: {'id': movie.id, 'isMovie': isMovie},
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

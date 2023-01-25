import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:search/domain/usecases/search_movies.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(const SearchState()) {
    on<InitEvent>((event, emit) async {
      emit(state.copyWith(state: RequestState.Empty));
    });

    on<OnQueryChanged>((event, emit) async {
      emit(state.copyWith(state: RequestState.Loading));
      final result = await _searchMovies.execute(event.query, event.isMovie);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              state: RequestState.Error,
              message: failure.message,
            ),
          );
        },
        (data) {
          emit(
            state.copyWith(
              state: RequestState.Loaded,
              movies: data,
            ),
          );
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

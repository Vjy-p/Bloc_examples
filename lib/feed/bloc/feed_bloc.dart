import 'dart:developer';

import 'package:bloc_examples/feed/data/feed_services.dart';
import 'package:bloc_examples/feed/models/feed_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedServices api = FeedServices();

  static const int _limit = 10;

  FeedBloc() : super(const FeedState()) {
    on<FetchPosts>(_onFetchPosts);
    on<ClearPosts>(_onClearPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<FeedState> emit) async {
    log("get feed started ${state.status} ${state.hasMore}");
    if (state.status == FeedStatus.loading ||
        state.status == FeedStatus.paginationLoading ||
        !state.hasMore) {
      return;
    } else {
      try {
        emit(
          state.copyWith(
            status: state.page <= 1 || state.status == FeedStatus.initial
                ? FeedStatus.loading
                : FeedStatus.paginationLoading,
            page: state.status == FeedStatus.initial ? 1 : state.page,
          ),
        );

        List<FeedModel> defaultPosts = List.from(state.posts);
        int page = state.page;

        final resp = await api.fetchPosts(page: state.page, limit: _limit);
        if (resp != null) {
          List<FeedModel> feedPosts = List.of(resp);
          List<FeedModel> posts = defaultPosts..addAll(feedPosts);
          page++;
          emit(
            state.copyWith(
              status: FeedStatus.loaded,
              posts: posts,
              hasMore: feedPosts.length >= _limit,
              page: page,
            ),
          );
          log("get feed ended ${state.status} ${state.hasMore}");
        } else {
          emit(
            state.copyWith(
              status: page > 1 ? FeedStatus.paginationError : FeedStatus.error,
            ),
          );
        }
      } catch (e) {
        log("Error geeting feed $e");
        emit(
          state.copyWith(
            status: state.page > 1
                ? FeedStatus.paginationError
                : FeedStatus.error,
          ),
        );
      }
    }
  }

  Future<void> _onClearPosts(ClearPosts event, Emitter<FeedState> emit) async {
    emit(
      state.copyWith(
        status: FeedStatus.initial,
        posts: [],
        hasMore: true,
        page: 1,
      ),
    );
  }
}

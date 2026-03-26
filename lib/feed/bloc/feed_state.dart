import 'package:bloc_examples/feed/models/feed_model.dart';

enum FeedStatus {
  initial,
  loading,
  error,
  paginationLoading,
  paginationError,
  loaded,
}

class FeedState {
  final FeedStatus status;
  final List<FeedModel> posts;
  final bool hasMore;
  final int page;

  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.hasMore = true,
    this.page = 1,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<FeedModel>? posts,
    bool? hasMore,
    int? page,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

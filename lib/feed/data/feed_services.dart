import 'package:bloc_examples/feed/models/feed_model.dart';

class FeedServices {
  Future<List<FeedModel>?> fetchPosts({
    required int page,
    required int limit,
  }) async {
    await Future.delayed(Duration(seconds: 2));

    return List.generate(limit, (index) {
      return FeedModel(
        id: 'id_${page}_$index',
        imageUrl: 'https://picsum.photos/200/300?random=$page$index',
        caption: 'Post $index from page $page',
        isLiked: false,
      );
    });
  }
}

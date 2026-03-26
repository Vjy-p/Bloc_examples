class FeedModel {
  String id;
  String imageUrl;
  String caption;
  bool isLiked;

  FeedModel({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.isLiked,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
    id: json['id'],
    imageUrl: json['imageUrl'],
    caption: json['caption'],
    isLiked: json['isLiked'],
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'caption': caption,
    'isLiked': isLiked,
  };
}

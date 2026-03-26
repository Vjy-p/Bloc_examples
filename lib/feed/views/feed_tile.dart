import 'package:bloc_examples/feed/models/feed_model.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class FeedTile extends StatefulWidget {
  const FeedTile({super.key, required this.post});
  final FeedModel post;

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  bool isLoading = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isLiked = widget.post.isLiked;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(radius: 12),
                Expanded(
                  child: customText(
                    text: widget.post.id,
                    maxLines: 1,
                    color: kWhiteColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            width: MediaQuery.of(context).size.width,
            height: 500,
            placeholder: (context, url) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const CircularProgressIndicator()],
            ),
            errorWidget: (context, url, error) {
              return Icon(Icons.error, size: 30);
            },
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 20,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.zero,
                  splashColor: Colors.transparent,
                  onPressed: isLoading
                      ? null
                      : () {
                          isLoading = true;
                          setState(() {});
                          isLiked = !isLiked;
                          isLoading = false;
                          setState(() {});
                        },
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    color: kWhiteColor,
                  ),
                ),
                ReadMoreText(
                  "${widget.post.id}  ${widget.post.caption}",
                  trimMode: TrimMode.Line,
                  style: customTextStyle(fontSize: 14, color: kWhiteColor),
                  trimCollapsedText: " ",
                  trimExpandedText: "  show less",
                  moreStyle: customTextStyle(color: kTextSecondaryColor),
                  lessStyle: customTextStyle(color: kTextSecondaryColor),
                  delimiterStyle: customTextStyle(color: kTextSecondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

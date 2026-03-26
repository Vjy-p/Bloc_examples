import 'package:bloc_examples/feed/bloc/feed_bloc.dart';
import 'package:bloc_examples/feed/bloc/feed_event.dart';
import 'package:bloc_examples/feed/bloc/feed_state.dart';
import 'package:bloc_examples/feed/views/feed_tile.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/cuatom_button.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context.read<FeedBloc>().add(FetchPosts());
    addScroll();
    super.initState();
  }

  void addScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<FeedBloc>().add(FetchPosts());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBgColor,
          appBar: AppBar(
            title: customText(
              text: "Feed Screen",
              fontSize: 20,
              color: kTextSecondaryColor,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: kBgColor,
            surfaceTintColor: kBgColor,
          ),
          body: SafeArea(
            child: state.status == FeedStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : state.status == FeedStatus.error
                ? Center(
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText(
                          text: "Something went wrong!",
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: kGreyColor,
                        ),
                        customButton(
                          text: "Retry",
                          onTap: () {
                            context.read<FeedBloc>().add(FetchPosts());
                          },
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: state.posts.length + 1,
                    padding: EdgeInsets.only(bottom: 30),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (state.posts.length == index) {
                        return state.status == FeedStatus.paginationLoading
                            ? const Padding(
                                padding: EdgeInsetsGeometry.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                ),
                              )
                            : state.status == FeedStatus.paginationError
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: IconButton(
                                  onPressed: () {
                                    context.read<FeedBloc>().add(FetchPosts());
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 30,
                                    color: kWhiteColor,
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }
                      return FeedTile(post: state.posts[index]);
                    },
                  ),
          ),
        );
      },
    );
  }
}

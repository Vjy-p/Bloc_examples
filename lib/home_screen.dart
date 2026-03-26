import 'package:bloc_examples/chat_bot/views/chat_bot_screen.dart';
import 'package:bloc_examples/feed/views/feed_screen.dart';
import 'package:bloc_examples/products/views/products_screen.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [FeedScreen(), ProductsScreen()];

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.text_snippet_outlined),
      tooltip: "Posts",
      label: "Posts",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.image_outlined),
      tooltip: "Products",
      label: "Products",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBgColor,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        items: items,
        currentIndex: currentIndex,
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
        selectedIconTheme: IconThemeData(color: kGreyColor),
        selectedLabelStyle: customTextStyle(
          color: kGreyColor,
          fontWeight: FontWeight.w900,
        ),
        selectedItemColor: kGreyColor,
        unselectedIconTheme: IconThemeData(
          color: kGreyColor.withValues(alpha: 0.5),
        ),
        unselectedItemColor: kGreyColor.withValues(alpha: 0.5),
        unselectedLabelStyle: customTextStyle(
          color: kGreyColor.withValues(alpha: 0.5),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: kButtonColor,
        onPressed: () {
          // Navigator.of(
          //   context,
          // ).push(MaterialPageRoute(builder: (_) => ChatScreen()));

          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => ChatBotScreen()));
        },
        child: Icon(Icons.sms, color: kTextSecondaryColor),
      ),
    );
  }
}

import 'package:bloc_examples/cart/bloc/cart_bloc.dart';
import 'package:bloc_examples/chat/bloc/chat_bloc.dart';
import 'package:bloc_examples/feed/bloc/feed_bloc.dart';
import 'package:bloc_examples/home_screen.dart';
import 'package:bloc_examples/products/bloc/products_bloc.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FeedBloc()),
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: kPrimaryColor)),
        home: HomeScreen(),
      ),
    );
  }
}

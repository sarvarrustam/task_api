import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_api/home_page/home_provider.dart';
import 'package:task_api/home_page/home_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(context),
      lazy: false,
      child: Builder(builder: (context) {
        return const HomeView();
      }),
    );
  }
}

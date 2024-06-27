import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall_app/componets/network/provider/network_provider.dart';
import 'package:mirror_wall_app/componets/network/view/network_screen.dart';
import 'package:mirror_wall_app/screen/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? providerW;
  HomeProvider? providerR;

  @override
  Widget build(BuildContext context) {
    providerW = context.watch<HomeProvider>();
    providerW = context.read<HomeProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Android"),
        ),
        body: context.watch<NetworkProvider>().isInterNet
            ? Column(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url:WebUri("https://www.google.com/") ),
            )
          ],
        )
            : const NetworkWidget(),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark),label: "Bookmark"),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back),label: "Bake"),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_forward),label: "Forward"),
          BottomNavigationBarItem(icon: Icon(Icons.refresh),label: "refresh"),

        ],
      ),
    );
  }
}

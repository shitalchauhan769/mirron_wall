import 'package:flutter/material.dart';
import 'package:mirror_wall_app/componets/network/provider/network_provider.dart';
import 'package:mirror_wall_app/screen/home/provider/home_provider.dart';
import 'package:mirror_wall_app/until/routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value:NetworkProvider()..checkConnectivity()),
        ChangeNotifierProvider.value(value:HomeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: app_routes,
      ),
    ),
  );
}

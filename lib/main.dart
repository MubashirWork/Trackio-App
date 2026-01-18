import 'package:flutter/material.dart';
import 'package:trackio/core/data/service/snack_bar_service.dart';
import 'package:trackio/routes/app_routes.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'core/constants/app_strings.dart' show AppStrings;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStrings.getAppData();
  runApp(const Trackio());
}

class Trackio extends StatelessWidget {
  const Trackio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackio',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: SnackBarService.key,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

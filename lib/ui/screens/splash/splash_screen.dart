import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/core/constants/app_strings.dart';
import 'package:trackio/core/data/shared_preference/service/shared_prefs_service.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  // Checks user state and based on state navigates after splash
  Future isLoggedIn() async {
    await Future.delayed(Duration(seconds: 1));
    final getState = await SharedPrefsService.isLoggedIn();
    if (getState == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.dashboard,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.darkBlue, AppColors.blue, AppColors.lightBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // App logo
                Image(
                  image: AssetImage(AppStrings.logo),
                  height: MediaQuery.of(context).size.height * 0.12,
                ),

                const SizedBox(height: 16),

                // App name
                AppText(
                  data: AppStrings.appName,
                  size: 30,
                  color: AppColors.white,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

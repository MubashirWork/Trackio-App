import 'package:flutter/material.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/screens/auth/forgot_password_screen.dart';
import 'package:trackio/ui/screens/auth/login_screen.dart';
import 'package:trackio/ui/screens/auth/sign_up_screen.dart';
import 'package:trackio/ui/screens/dashboard/dashboard_screen.dart';
import 'package:trackio/ui/screens/edit_name/edit_name_screen.dart';
import 'package:trackio/ui/screens/logs/logs_history_screen.dart';
import 'package:trackio/ui/screens/profile/profile_screen.dart';
import 'package:trackio/ui/screens/splash/splash_screen.dart';

class AppRoutes {

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {

    switch(settings.name) {
      case RouteNames.splash: 
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteNames.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RouteNames.logsHistory:
        return MaterialPageRoute(builder: (_) => const LogsHistoryScreen());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouteNames.editName:
        return MaterialPageRoute(builder: (_) => const EditNameScreen());
      default:
        return null;
    }
  }
}
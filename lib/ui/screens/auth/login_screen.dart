import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/core/constants/app_strings.dart';
import 'package:trackio/core/data/database/Dao/user/user_dao.dart';
import 'package:trackio/core/data/database/constants/user/user.dart';
import 'package:trackio/core/data/service/snack_bar_service.dart';
import 'package:trackio/core/data/shared_preference/service/shared_prefs_service.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/widgets/app_elevated_button.dart';
import 'package:trackio/ui/widgets/app_text.dart';
import 'package:trackio/ui/widgets/app_text_button.dart';
import 'package:trackio/ui/widgets/app_text_field.dart';
import 'package:trackio/ui/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool isLoading = false;

  bool hidePassword = true;


  // Handles user login and stores data
  Future<void> login() async {

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (email.isEmpty) {
      setState(() => emailError = 'Email is required');
      return;
    }
    if (password.isEmpty) {
      setState(() => passwordError = 'Password is required');
      return;
    }

    setState(() => isLoading = true);

    final loginUser = await UserDao.instance.loginUser(email);

    await Future.delayed(Duration(milliseconds: 300));

    setState(() => isLoading = false);

    if (loginUser.isEmpty) {
      setState(() => emailError = "Email does not exist");
      return;
    }

    if (loginUser.first[User.password] != password) {
      setState(() => passwordError = "Password is incorrect");
      return;
    }

    if (loginUser.isNotEmpty) {

      // Saving login state locally
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.setBool(SharedPrefsService.loginKey, true);
      prefs.setString(SharedPrefsService.email, email);
      final fullName = loginUser.first[User.fullName];
      prefs.setString(SharedPrefsService.fullName, fullName);

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.dashboard,
        (routes) => false,
      );
      SnackBarService.show('Logged in successfully');
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeHeight =
        mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,

      // Bottom navigation for sign up
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AppText(
                  data: "Don't have an account?",
                  color: AppColors.white,
                ),
              ),
              AppTextButton(
                onClick: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.signup,
                    (route) => false,
                  );
                },
                text: 'Sign Up',
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: safeHeight),
            child: Padding(
              padding: EdgeInsets.only(
                top: 16,
                right: 16,
                left: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // App logo and name title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(AppStrings.logo),
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          data: AppStrings.appName,
                          color: AppColors.white,
                          size: 32,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      data: 'Welcome Back!',
                      color: AppColors.white,
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.email, color: AppColors.blue),
                        const SizedBox(width: 8),
                        AppText(
                          data: 'Email',
                          color: AppColors.white,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Email text field
                    AppTextField(
                      showBorder: true,
                      controller: emailController,
                      onChange: (_) {
                        if (emailError != null) {
                          setState(() => emailError = null);
                        }
                      },
                      errorText: emailError,
                      leadingIcon: Icons.email,
                      hint: AppText(
                        data: 'Enter your email',
                        color: AppColors.lightGray,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      keyboardAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.lock, color: AppColors.blue),
                        const SizedBox(width: 8),
                        AppText(
                          data: 'Password',
                          color: AppColors.white,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Password text field
                    AppTextField(
                      showBorder: true,
                      controller: passwordController,
                      onChange: (_) {
                        if (passwordError != null) {
                          setState(() => passwordError = null);
                        }
                      },
                      errorText: passwordError,
                      leadingIcon: Icons.lock,
                      hint: AppText(
                        data: 'Enter your password',
                        color: AppColors.lightGray,
                      ),
                      trailingOnClick: () {
                        setState(() => hidePassword = !hidePassword);
                      },
                      trailingIcon: hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      obscureText: hidePassword,
                      keyboardType: TextInputType.visiblePassword,
                      keyboardAction: TextInputAction.done,
                      onComplete: () {
                        FocusScope.of(context).unfocus();
                        login();
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: AppTextButton(
                        onClick: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.forgotPassword,
                            (route) => false,
                          );
                        },
                        text: 'Forgot Password?',
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppElevatedButton(
                      onClick: login,
                      child: isLoading
                          ? LoadingIndicator()
                          : AppText(
                              data: 'Login',
                              color: AppColors.white,
                              weight: FontWeight.w500,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

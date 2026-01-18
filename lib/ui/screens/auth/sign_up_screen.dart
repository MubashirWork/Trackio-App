import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/core/constants/app_strings.dart';
import 'package:trackio/core/data/database/Dao/user/user_dao.dart';
import 'package:trackio/core/data/service/snack_bar_service.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/widgets/app_container.dart';
import 'package:trackio/ui/widgets/app_elevated_button.dart';
import 'package:trackio/ui/widgets/app_text.dart';
import 'package:trackio/ui/widgets/app_text_button.dart';
import 'package:trackio/ui/widgets/app_text_field.dart';
import 'package:trackio/ui/widgets/loading_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? fullNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool isLoading = false;

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // Registering user and storing data
  Future<void> register() async {

    setState(() {
      fullNameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    if (fullNameController.text.trim().isEmpty) {
      setState(() => fullNameError = 'Full Name is required');
      return;
    }
    if (emailController.text.trim().isEmpty) {
      setState(() => emailError = 'Email is required');
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      setState(() => passwordError = 'Password is required');
      return;
    }
    if (passwordController.text.trim().length < 8) {
      setState(() => passwordError = 'Password must be at least 8 characters');
      return;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      setState(() => confirmPasswordError = 'Confirm password is required');
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      setState(() => confirmPasswordError = 'Passwords do not match');
      return;
    }

    setState(() => isLoading = true);

    final register = await UserDao.instance.registerUser(
      fullNameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      confirmPasswordController.text.trim(),
    );

    await Future.delayed(Duration(milliseconds: 300));

    setState(() => isLoading = false);

    if (register) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (route) => false,
      );
      SnackBarService.show('Account created successfully');
    } else {
      setState(() => emailError = 'Email already exists');
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeHeight =
        mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,

      // Bottom navigation for login
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AppText(
                  data: "Already have an account?",
                  color: AppColors.darkBlue,
                ),
              ),
              AppTextButton(
                onClick: () {
                  Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (route) => false);
                },
                text: 'Login',
                textColor: AppColors.blue,
              ),
            ],
          ),
        ),
      ),
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
                          color: AppColors.darkBlue,
                          size: 32,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      data: 'Create an Account',
                      color: AppColors.darkBlue,
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      data: 'Sign up to get started!',
                      color: AppColors.darkBlue,
                    ),

                    const SizedBox(height: 16),

                    AppContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: AppColors.blue),
                              const SizedBox(width: 8),
                              AppText(
                                data: 'Full Name',
                                color: AppColors.darkBlue,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),

                          // fullName text field
                          AppTextField(
                            controller: fullNameController,
                            onChange: (_) {
                              if (fullNameError != null) {
                                setState(() => fullNameError = null);
                              }
                            },
                            hint: AppText(
                              data: 'Enter your full name',
                              color: AppColors.darkBlue,
                            ),
                            textColor: AppColors.darkBlue,
                            showBorder: false,
                            isDense: true,
                            verticalPadding: 2,
                            horizontalPadding: 32,
                            errorText: fullNameError,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    AppContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email, color: AppColors.blue),
                              const SizedBox(width: 8),
                              AppText(
                                data: 'Email',
                                color: AppColors.darkBlue,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),

                          // Email text field
                          AppTextField(
                            controller: emailController,
                            onChange: (_) {
                              if (emailError != null) {
                                setState(() => emailError = null);
                              }
                            },
                            errorText: emailError,
                            hint: AppText(
                              data: 'Enter your email',
                              color: AppColors.darkBlue,
                            ),
                            textColor: AppColors.darkBlue,
                            showBorder: false,
                            isDense: true,
                            verticalPadding: 2,
                            horizontalPadding: 32,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    AppContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock, color: AppColors.blue),
                              const SizedBox(width: 8),
                              AppText(
                                data: 'Password',
                                color: AppColors.darkBlue,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),

                          // Password text field
                          AppTextField(
                            controller: passwordController,
                            onChange: (_) {
                              if (passwordError != null) {
                                setState(() => passwordError = null);
                              }
                            },
                            errorText: passwordError,
                            hint: AppText(
                              data: 'Create a password',
                              color: AppColors.darkBlue,
                            ),
                            textColor: AppColors.darkBlue,
                            showBorder: false,
                            isDense: true,
                            verticalPadding: 2,
                            horizontalPadding: 32,
                            keyboardType: TextInputType.visiblePassword,
                            trailingOnClick: () {
                              setState(() => hidePassword = !hidePassword);
                            },
                            trailingIcon: hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            obscureText: hidePassword,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    AppContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock, color: AppColors.blue),
                              const SizedBox(width: 8),
                              AppText(
                                data: 'Confirm Password',
                                color: AppColors.darkBlue,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),

                          // Confirm password text field
                          AppTextField(
                            controller: confirmPasswordController,
                            onChange: (_) {
                              if (confirmPasswordError != null) {
                                setState(() => confirmPasswordError = null);
                              }
                            },
                            errorText: confirmPasswordError,
                            hint: AppText(
                              data: 'Confirm your password',
                              color: AppColors.darkBlue,
                            ),
                            textColor: AppColors.darkBlue,
                            showBorder: false,
                            isDense: true,
                            verticalPadding: 2,
                            horizontalPadding: 32,
                            keyboardType: TextInputType.visiblePassword,
                            keyboardAction: TextInputAction.done,
                            onComplete: () {
                              FocusScope.of(context).unfocus();
                              register();
                            },
                            trailingIcon: hideConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            trailingOnClick: () {
                              setState(
                                () =>
                                    hideConfirmPassword = !hideConfirmPassword,
                              );
                            },
                            obscureText: hideConfirmPassword,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    AppElevatedButton(
                      onClick: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        register();
                      },
                      child: isLoading
                          ? LoadingIndicator()
                          : AppText(
                              data: 'Sign Up',
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

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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  String? emailError;
  String? newPasswordError;
  String? confirmNewPasswordError;

  bool isLoading = false;

  bool hideNewPassword = true;
  bool hideConfirmNewPassword = true;

  // Updating password of user
  Future<void> update() async {

    setState(() {
      emailError = null;
      newPasswordError = null;
      confirmNewPasswordError = null;
    });

    if (emailController.text.trim().isEmpty) {
      setState(() => emailError = 'Email is required');
      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      setState(() => newPasswordError = 'New Password is required');
      return;
    }

    if (confirmNewPasswordController.text.trim().isEmpty) {
      setState(
        () => confirmNewPasswordError = 'Confirming new password is required',
      );
      return;
    }

    if (newPasswordController.text.trim() !=
        confirmNewPasswordController.text.trim()) {
      setState(() => confirmNewPasswordError = 'Passwords do not match');
      return;
    }

    setState(() => isLoading = true);

    final updatePassword = await UserDao.instance.updatePassword(
      emailController.text.trim(),
      newPasswordController.text.trim(),
      confirmNewPasswordController.text.trim(),
    );

    await Future.delayed(Duration(milliseconds: 300));

    setState(() => isLoading = false);

    if (updatePassword) {
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (route) => false);
      SnackBarService.show('Password changed successfully');
    } else {
      setState(() => emailError = 'Email does not exist');
    }
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
      backgroundColor: AppColors.white,
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
                      data: 'Forgot Password?',
                      color: AppColors.darkBlue,
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      data: 'Reset your account password',
                      color: AppColors.darkBlue,
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
                          const SizedBox(height: 8),

                          // Email text field
                          AppTextField(
                            showBorder: true,
                            textColor: AppColors.darkBlue,
                            controller: emailController,
                            onChange: (_) {
                              if (emailError != null) {
                                setState(() => emailError = null);
                              }
                            },
                            errorText: emailError,
                            hint: AppText(
                              data: 'Enter your email address',
                              color: AppColors.darkBlue,
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
                                data: 'New Password',
                                color: AppColors.darkBlue,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // New password text field
                          AppTextField(
                            showBorder: true,
                            textColor: AppColors.darkBlue,
                            controller: newPasswordController,
                            onChange: (_) {
                              if (newPasswordError != null) {
                                setState(() => newPasswordError = null);
                              }
                            },
                            errorText: newPasswordError,
                            hint: AppText(
                              data: 'Enter your new password',
                              color: AppColors.darkBlue,
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            keyboardAction: TextInputAction.next,
                            trailingIcon: hideNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            trailingOnClick: () {
                              setState(
                                () => hideNewPassword = !hideNewPassword,
                              );
                            },
                            obscureText: hideNewPassword,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Icon(Icons.lock, color: AppColors.blue),
                              const SizedBox(width: 8),
                              AppText(
                                data: 'Confirm New Password',
                                color: AppColors.darkBlue,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Confirm new password text field
                          AppTextField(
                            showBorder: true,
                            textColor: AppColors.darkBlue,
                            controller: confirmNewPasswordController,
                            onChange: (_) {
                              if (confirmNewPasswordError != null) {
                                setState(() => confirmNewPasswordError = null);
                              }
                            },
                            errorText: confirmNewPasswordError,
                            hint: AppText(
                              data: 'Confirm new password',
                              color: AppColors.darkBlue,
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            keyboardAction: TextInputAction.done,
                            trailingIcon: hideConfirmNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            trailingOnClick: () {
                              setState(
                                () => hideConfirmNewPassword =
                                    !hideConfirmNewPassword,
                              );
                            },
                            obscureText: hideConfirmNewPassword,
                            onComplete: () {
                              FocusScope.of(context).unfocus();
                              update();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppElevatedButton(
                      onClick: update,
                      child: isLoading
                          ? LoadingIndicator()
                          : AppText(
                              data: 'Reset Password',
                              color: AppColors.white,
                              weight: FontWeight.w500,
                            ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Divider(color: AppColors.lightGray),
                    ),
                    AppText(
                      data: 'Remembered your password?',
                      color: AppColors.darkBlue,
                    ),
                    AppTextButton(
                      onClick: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.login,
                          (route) => false,
                        );
                      },
                      text: 'Back to Login',
                      textColor: AppColors.blue,
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

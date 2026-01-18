import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/core/data/database/Dao/user/user_dao.dart';
import 'package:trackio/core/data/service/snack_bar_service.dart';
import 'package:trackio/core/data/shared_preference/service/shared_prefs_service.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/widgets/app_bar.dart';
import 'package:trackio/ui/widgets/app_elevated_button.dart';
import 'package:trackio/ui/widgets/app_text.dart';
import 'package:trackio/ui/widgets/app_text_field.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final TextEditingController fullNameController = TextEditingController();
  String? fullName;
  String? email;

  @override
  void initState() {
    super.initState();
    getFullName();
  }

  // Getting user fullName
  Future getFullName() async {
    final getUserFullName = await SharedPrefsService.getName();
    final getEmail = await SharedPrefsService.getEmail();
    if (getUserFullName != null) setState(() => fullName = getUserFullName);
    if (getEmail != null) setState(() => email = getEmail);

    setState(() => fullNameController.text = fullName ?? '');
  }

  // Changing user fullName
  Future changeName() async {
    final change = await UserDao.instance.updateFullName(
      email!,
      fullNameController.text.trim(),
    );
    if (change) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (route) => false,
      );
      SnackBarService.show('Named changed');
    } else {
      SnackBarService.show('Named does not updated');
      return;
    }
  }

  String initial(String fullName) {

    final name = fullName.trim();

    if (name.isEmpty) {
      return '';
    }
    final split = name.split(" ");
    if (split.length > 1) {
      return "${split[0][0]}${split[1][0]}".toUpperCase();
    } else {
      return split[0][0].toUpperCase();
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: Appbar(
        iconOnClick: () {
          Navigator.maybePop(context);
        },
        leadingIcon: Icons.arrow_back_ios,
        text: 'Edit Name',
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grayish, width: 4),
                ),

                // Circular avatar
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.blue,
                  child: AppText(
                    data: initial(fullName ?? ""),
                    color: AppColors.white,
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // User email
              AppText(data: email ?? ''),
              const SizedBox(height: 16),

              // FullName text field
              AppTextField(
                textColor: AppColors.darkGray,
                controller: fullNameController,
                hint: AppText(data: ''),
                showBorder: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppElevatedButton(
                      onClick: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: AppColors.white,
                      child: AppText(
                        data: 'Cancel',
                        color: AppColors.darkGray,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppElevatedButton(
                      onClick: changeName,
                      child: AppText(
                        data: 'Save',
                        color: AppColors.white,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

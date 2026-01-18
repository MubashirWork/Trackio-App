import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/core/constants/app_strings.dart';
import 'package:trackio/core/data/shared_preference/service/shared_prefs_service.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/screens/profile/model/items.dart';
import 'package:trackio/ui/widgets/app_bar.dart';
import 'package:trackio/ui/widgets/app_container.dart';
import 'package:trackio/ui/widgets/app_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fullName;
  String? email;

  List<Items> containerItems = [
    Items(Icons.person, 'Change Name', AppColors.darkGray),
    Items(Icons.lock, 'Change Password', Colors.amber),
    Items(Icons.logout, 'Logout', Colors.red),
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Getting email and name from local storage
  Future<void> getData() async {
    final getFullName = await SharedPrefsService.getName();
    final getEmail = await SharedPrefsService.getEmail();

    if (getFullName != null) setState(() => fullName = getFullName);
    if (getEmail != null) setState(() => email = getEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Profile screen bottom bar (shows app logo, name and version)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage(AppStrings.logo),
                height: MediaQuery.of(context).size.height * 0.06,
              ),

              AppText(
                data: AppStrings.appName,
                color: AppColors.darkBlue,
                size: 18,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 4),
              AppText(data: 'Version ${AppStrings.appVersion}'),
              AppText(data: AppStrings.copyRightText),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.white,

      // App bar
      appBar: Appbar(
        iconOnClick: () {
          Navigator.maybePop(context);
        },
        leadingIcon: Icons.arrow_back_ios,
        text: 'Profile',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                // Profile icon image
                Image(
                  image: AssetImage(AppStrings.profileImage),
                  height: MediaQuery.of(context).size.height * 0.10,
                ),

                const SizedBox(height: 16),

                // User fullName
                AppText(
                  data: fullName ?? "User",
                  size: 18,
                  weight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),

                const SizedBox(height: 4),

                // User email
                AppText(data: email ?? 'user@gmail.com'),
                const SizedBox(height: 16),
                Divider(thickness: 0.5, color: AppColors.lightGray),
                const SizedBox(height: 16),

                // Clickable containers to edit profile
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: containerItems.length,
                  itemBuilder: (context, index) {
                    final item = containerItems[index];
                    return GestureDetector(
                      onTap: () async {

                        final prefs = await SharedPreferences.getInstance();

                        switch (index) {
                          case 0:
                            Navigator.pushNamed(context, RouteNames.editName);
                            return;
                          case 1:

                            prefs.setBool(SharedPrefsService.loginKey, false);

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteNames.forgotPassword,
                              (route) => false,
                            );
                            return;
                          case 2:

                              prefs.setBool(SharedPrefsService.loginKey, false);

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.login,
                                (route) => false,
                              );
                              return;
                        }
                      },
                      child: AppContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(item.leadingIcon, color: item.color),
                                const SizedBox(width: 8),
                                AppText(data: item.title),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, _) => SizedBox(height: 16),
                ),
                const SizedBox(height: 16),
                Divider(thickness: 0.5, color: AppColors.lightGray),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/core/data/database/Dao/logs/logs_dao.dart';
import 'package:trackio/core/data/service/snack_bar_service.dart';
import 'package:trackio/core/data/shared_preference/service/shared_prefs_service.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/widgets/app_bar.dart';
import 'package:trackio/ui/widgets/app_container.dart';
import 'package:trackio/ui/widgets/app_drawer.dart';
import 'package:trackio/ui/widgets/app_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? inTime;
  String? outTime;

  List<String> text = ['Check In', 'Check Out'];
  List<String> checkInOutTime = ['Check In', 'Check Out'];

  String? fullName;
  String? email;

  @override
  void initState() {
    super.initState();
    getData();
    getLastCheckInOut();
  }

  // Getting last check in out from shared prefs
  Future<void> getLastCheckInOut() async {
    final lastIn = await SharedPrefsService.getLastIn();
    final lastOut = await SharedPrefsService.getLastOut();

    if (lastIn != null &&
        lastIn.isNotEmpty &&
        (lastOut == null || lastOut.isEmpty)) {
      final formattedIn = formatTime(lastIn);
      setState(() {
        checkInOutTime[0] = 'Checked In At: $formattedIn';
        checkInOutTime[1] = 'Check Out';
        inTime = lastIn;
        outTime = null;
      });
    } else {
      setState(() {
        checkInOutTime[0] = 'Check In';
        checkInOutTime[1] = 'Check Out';
        inTime = null;
        outTime = null;
      });
    }
  }

  // Getting fullName and email
  Future<void> getData() async {
    final getName = await SharedPrefsService.getName();
    final getEmail = await SharedPrefsService.getEmail();
    if (getName != null) {
      setState(() => fullName = getName);
    }

    if (getEmail != null) {
      setState(() => email = getEmail);
    }
  }

  // Time formating
  String formatTime(String isoTime) {
    final dateTime = DateTime.parse(isoTime);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App drawer
      drawer: AppDrawer(),
      backgroundColor: AppColors.white,

      // Appbar
      appBar: Appbar(text: 'Dashboard'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(data: 'Hello! $fullName', size: 16),
              const SizedBox(height: 8),

              // Check in & check out card using list view
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = text[index];
                    final checkInOutItem = checkInOutTime[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        const SizedBox(height: 16),
                        AppContainer(
                          borderColor: AppColors.semiBlack,
                          borderWidth: 1,
                          padding: 0,
                          child: Column(
                            children: [
                              AppContainer(
                                containerColor: AppColors.grayish,
                                borderColor: AppColors.semiBlack,
                                padding: 16,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: AppColors.darkGray,
                                    ),
                                    const SizedBox(width: 8),
                                    AppText(
                                      data: item,
                                      color: AppColors.darkGray,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 32,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();

                                    final currentTime = DateTime.now()
                                        .toIso8601String();

                                    // User taps on check in
                                    if (index == 0) {
                                      if (inTime != null) {
                                        SnackBarService.show(
                                          'Already checked in',
                                        );
                                        return;
                                      }
                                      setState(() {
                                        inTime = currentTime;
                                        final displayFormated = formatTime(
                                          currentTime,
                                        );
                                        checkInOutTime[0] =
                                            'Checked In At: $displayFormated';
                                      });

                                      prefs.setString(
                                        SharedPrefsService.lastIn,
                                        currentTime,
                                      );
                                      SnackBarService.show(
                                        'Checked in successfully',
                                      );
                                    } else if (index == 1) {
                                      // User tap on check out
                                      if (inTime == null || inTime!.isEmpty) {
                                        SnackBarService.show(
                                          'Please check in first',
                                        );
                                        return;
                                      }

                                      if (outTime != null) {
                                        SnackBarService.show(
                                          'Already checked out',
                                        );
                                        return;
                                      }

                                      setState(() {
                                        outTime = currentTime;
                                        final displayFormated = formatTime(
                                          currentTime,
                                        );
                                        checkInOutTime[1] =
                                            'Checked Out At: $displayFormated';
                                      });

                                      // Calculating hours
                                      DateTime inDateTime = DateTime.parse(
                                        inTime!,
                                      );

                                      DateTime outDateTime = DateTime.parse(
                                        outTime!,
                                      );

                                      Duration difference = outDateTime
                                          .difference(inDateTime);
                                      final hours =
                                          "${difference.inHours.toString().padLeft(2, '0')}h ${(difference.inMinutes % 60).toString().padLeft(2, '0')}m";

                                      await LogsDao.instance.storeData(
                                        email!,
                                        DateFormat(
                                          'EEEE dd MMMM, yyyy',
                                        ).format(DateTime.now()),
                                        DateFormat(
                                          'HH:mm:ss',
                                        ).format(DateTime.parse(inTime!)),
                                        DateFormat(
                                          'HH:mm:ss',
                                        ).format(DateTime.parse(outTime!)),
                                        hours,
                                      );

                                      prefs.setString(
                                        SharedPrefsService.lastIn,
                                        '',
                                      );
                                      prefs.setString(
                                        SharedPrefsService.lastOut,
                                        '',
                                      );

                                      SnackBarService.show(
                                        'Checked out successfully',
                                      );
                                      await Future.delayed(
                                        Duration(seconds: 2),
                                      );

                                      // Reset inTime outTime for next session
                                      setState(() {
                                        inTime = null;
                                        outTime = null;
                                        checkInOutTime[0] = 'Check In';
                                        checkInOutTime[1] = 'Check Out';
                                      });
                                    }
                                  },
                                  child: AppContainer(
                                    containerColor: AppColors.grayish,
                                    borderColor: AppColors.semiBlack,
                                    borderWidth: 1,
                                    padding: 16,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_rounded,
                                          color: AppColors.darkGray,
                                        ),
                                        AppText(
                                          data: checkInOutItem,
                                          color: AppColors.darkGray,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                  itemCount: text.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/core/data/database/Dao/logs/logs_dao.dart';
import 'package:trackio/core/data/database/constants/logs/logs.dart';
import 'package:trackio/core/data/service/snack_bar_service.dart';
import 'package:trackio/core/data/shared_preference/service/shared_prefs_service.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/widgets/app_bar.dart';
import 'package:trackio/ui/widgets/app_container.dart';
import 'package:trackio/ui/widgets/app_text.dart';
import 'package:trackio/ui/widgets/app_text_button.dart';

class LogsHistoryScreen extends StatefulWidget {
  const LogsHistoryScreen({super.key});

  @override
  State<LogsHistoryScreen> createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen> {
  List myList = [];

  String? fullName;
  String? email;

  Duration total = Duration.zero;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  // Calculating total hours
  void calculateHours() {
    total = Duration.zero;

    for (final item in myList) {
      final parts = item[Logs.hours].split(" ");
      final h = int.parse(parts[0].replaceAll('h', ''));
      final m = int.parse(parts[1].replaceAll('m', ''));
      total += Duration(hours: h, minutes: m);
    }
  }

  // Fetching fullName and email
  Future<void> fetch() async {
    final getName = await SharedPrefsService.getName();
    final getEmail = await SharedPrefsService.getEmail();

    if (getName != null) setState(() => fullName = getName);
    if (getEmail != null) setState(() => email = getEmail);

    final fetchData = await LogsDao.instance.fetchData(email!);

    if (fetchData.isNotEmpty) {
      setState(() {
        myList = fetchData;
        calculateHours();
      });
    }
  }

  // Deleting logs
  Future<void> deleteData() async {
    final delete = await LogsDao.instance.deleteData(email!);

    if (delete) {
      SnackBarService.show('Logs history deleted');
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.dashboard,
        (route) => false,
      );
    } else {
      SnackBarService.show('Unable to delete logs history');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Setting column width
    final columnWidth = {
      0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15),
      1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.30),
      2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.25),
      3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.25),
      4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.20),
    };

    return Scaffold(
      backgroundColor: AppColors.white,

      // App bar
      appBar: Appbar(
        iconOnClick: () {
          Navigator.pop(context);
        },
        leadingIcon: Icons.arrow_back_ios,
        text: 'Logs History',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logged in user fullName
                AppText(
                  data: fullName ?? '',
                  size: 16,
                  weight: FontWeight.w500,
                ),
                const SizedBox(height: 16),
                AppContainer(
                  padding: 8,
                  containerColor: AppColors.grayish,
                  borderColor: AppColors.grayish,
                  child: Expanded(
                    child: AppText(
                      data: myList.isNotEmpty
                          ? 'Last Check In at: ${myList.last[Logs.date]}, Time: ${myList.last[Logs.checkIn]}'
                          : 'No check in record',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  // Table to show logs info
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: columnWidth,
                    border: TableBorder.all(
                      color: AppColors.lightGray,
                      width: 1,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        children: [
                          _TableData('S.No', textColor: AppColors.white),
                          _TableData('Date', textColor: AppColors.white),
                          _TableData('Check In', textColor: AppColors.white),
                          _TableData('Check Out', textColor: AppColors.white),
                          _TableData('Hours', textColor: AppColors.white),
                        ],
                      ),

                      ...List.generate(myList.length, (index) {
                        final item = myList[index];
                        return TableRow(
                          children: [
                            _TableData("${index + 1}"),
                            _TableData("${item[Logs.date]}"),
                            _TableData("${item[Logs.checkIn]}"),
                            _TableData("${item[Logs.checkOut]}"),
                            _TableData("${item[Logs.hours]}"),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: AppColors.blue),
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: _TableData(
                            'Total Hours ${total.inHours}h ${total.inMinutes % 60}m',
                            textColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: AppTextButton(
                    onClick: deleteData,
                    text: 'Delete History',
                    textColor: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TableData extends StatelessWidget {
  final String text;
  final Color textColor;

  const _TableData(this.text, {this.textColor = AppColors.darkGray});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: AppText(data: text, color: textColor),
    );
  }
}

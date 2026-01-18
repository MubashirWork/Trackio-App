import 'package:flutter/material.dart';
import 'package:trackio/core/constants/app_colors.dart';
import 'package:trackio/routes/constants/route_names.dart';
import 'package:trackio/ui/widgets/app_text.dart';

// App drawer
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var selectedIndex = 0;

  List<Map<String, dynamic>> menus = [
    {'icon': Icons.dashboard, 'title': 'Dashboard'},
    {'icon': Icons.history, 'title': 'Logs History'},
    {'icon': Icons.account_circle, 'title': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.60,
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(color: AppColors.blue),
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(data: 'Menu', color: AppColors.white),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.menu, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(4),
              itemBuilder: (context, index) {
                final item = menus[index];
                return ListTile(
                  onTap: () {

                    setState(() {
                      selectedIndex = index;
                    });

                    Navigator.pop(context);

                      switch (index) {
                        case 0:
                          Navigator.pushNamedAndRemoveUntil(context, RouteNames.dashboard, (route) => false);
                          break;
                        case 1:
                          Navigator.pushNamed(context, RouteNames.logsHistory);
                          break;
                        case 2:
                          Navigator.pushNamed(context, RouteNames.profile);
                          break;
                      }
                  },
                  selected: selectedIndex == index,
                  selectedTileColor: Color(0xFFD2D3D8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minTileHeight: MediaQuery.of(context).size.height * 0.06,
                  leading: Icon(item['icon'], color: AppColors.darkGray),
                  title: AppText(
                    data: item['title'],
                    color: AppColors.darkGray,
                  ),
                );
              },
              itemCount: menus.length,
              separatorBuilder: (context, _) => SizedBox(height: 4),
            ),
          ),
        ],
      ),
    );
  }
}

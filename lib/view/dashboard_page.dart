import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopy/view/pages/product_page.dart';
import 'package:shopy/view/pages/profile_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class DashboardPage extends StatefulWidget {


  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ProductPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 450),
          transitionBuilder: (Widget child, Animation<double> primaryAnimation, Animation<double> secondaryAnimation) {
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.black54,
            iconTheme: MaterialStateProperty.all(
                IconThemeData(color: Colors.white)
            ),
            labelTextStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)
            )
        ),
        child: NavigationBar(
          height: 50.h,
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.grey,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index){
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
                icon: Icon(CupertinoIcons.square_list),
                selectedIcon: Icon(CupertinoIcons.square_list_fill),
                label: AppLocalizations.of(context)!.product),
            NavigationDestination(
                icon: Icon(Icons.person_2_outlined),
                selectedIcon: Icon(Icons.person),
                label: AppLocalizations.of(context)!.profile)
          ],
        ),
      ),
    );
  }
}

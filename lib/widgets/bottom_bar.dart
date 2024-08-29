import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pocket_pal/model/observable.dart';

import '../screens/expense_screen.dart';
import '../screens/add_screen.dart';
import '../screens/income_screen.dart';
import '../screens/query_screen.dart';
import '../screens/settings_screen.dart';

class BottomBar extends StatelessWidget {
  Observable expensesChangeNotifier = Observable();

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  int currentIndex = 0;

  BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarItems(context),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      onItemSelected: (index) => {
        currentIndex = index,
      },
      navBarStyle: NavBarStyle.style15,
    );
  }

  List<Widget> _buildScreens() {
    return [
      ExpenseScreen(
        expensesChangeNotifier: expensesChangeNotifier,
      ),
      IncomeScreen(),
      AddScreen(
        pressedFromPage: currentIndex,
        expensesChangeNotifier: expensesChangeNotifier,
      ),
      QueryScreen(),
      SettingsScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.arrow_right_arrow_left),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
        activeColorPrimary: CupertinoColors.systemPurple,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        onPressed: (value) {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: AddScreen(
                  pressedFromPage: currentIndex,
                  expensesChangeNotifier: expensesChangeNotifier,
                ),
              );
            },
            isDismissible: true,
            isScrollControlled: true,
          );
        },
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.search),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.gear_solid),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}

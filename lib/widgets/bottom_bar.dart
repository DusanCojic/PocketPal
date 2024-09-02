import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/expense_screen.dart';
import '../screens/add_screen.dart';
import '../screens/income_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/settings_screen.dart';

class BottomBar extends StatelessWidget {
  static const BottomBar instance = BottomBar._internal();

  const BottomBar._internal();

  factory BottomBar() => instance;

  static final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  static bool hideNavBar = false;

  PersistentTabController get getController => _controller;

  static int currentIndex = 0;

  void hideBottomBar() => hideNavBar = true;
  void showBottomBar() => hideNavBar = false;

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      navBarHeight: 70,
      hideNavigationBar: hideNavBar,
      screens: _buildScreens(),
      items: _navBarItems(context),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
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
      const ExpenseScreen(),
      IncomeScreen(),
      AddScreen(
        pressedFromPage: currentIndex,
      ),
      QueryScreen(),
      SettingsScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home_rounded,
          size: 35.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.wallet_outlined,
          size: 35.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35.0,
        ),
        activeColorPrimary: Colors.orangeAccent,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        onPressed: (value) {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: AddScreen(
                  pressedFromPage: currentIndex,
                ),
              );
            },
            isDismissible: true,
            isScrollControlled: true,
          );
        },
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.bar_chart_rounded,
          size: 35.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.settings,
          size: 35.0,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}

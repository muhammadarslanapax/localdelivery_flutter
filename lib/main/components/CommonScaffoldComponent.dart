import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main.dart';
import '../utils/Colors.dart';
import '../utils/Widgets.dart';

class CommonScaffoldComponent extends StatelessWidget {
  final String? appBarTitle;
  final Widget? body;
  final bool? showBack;
  final PreferredSizeWidget? appBar;
  final List<Widget>? action;
  final bool? extendedBody;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? bottom;

  const CommonScaffoldComponent(
      {this.appBarTitle, this.body, this.action, this.appBar, this.showBack = true, this.extendedBody = false, this.floatingActionButton, this.floatingActionButtonLocation, this.bottomNavigationBar,this.bottom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendedBody.validate(),
      backgroundColor: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimaryLight,
      appBar: appBar ?? commonAppBarWidget(appBarTitle ?? '', actions: action, showBack: showBack!,bottom: bottom),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

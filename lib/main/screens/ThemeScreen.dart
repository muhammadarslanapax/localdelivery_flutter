import 'package:flutter/material.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import '../../main/components/BodyCornerWidget.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class ThemeScreen extends StatefulWidget {

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String _getName(ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return language.light;
      case ThemeModes.Dark:
        return language.dark;
      case ThemeModes.SystemDefault:
        return language.systemDefault;
    }
  }

  Widget _getIcons(BuildContext context, ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return Icon(LineIcons.sun, color: context.iconColor);
      case ThemeModes.Dark:
        return Icon(LineIcons.moon, color: context.iconColor);
      case ThemeModes.SystemDefault:
        return Icon(LineIcons.sun, color: context.iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(language.theme),
      body: ListView(
        children: List.generate(
          ThemeModes.values.length,
          (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
              child: Row(
                children: [
                  _getIcons(context, ThemeModes.values[index]),
                  16.width,
                  Text('${_getName(ThemeModes.values[index])}', style: boldTextStyle()).expand(),
                  if(index==currentIndex) Icon(Icons.check_circle,color: colorPrimary),
                ],
              ),
            ).onTap(() async {
              currentIndex = index;
              if (index == appThemeMode.themeModeSystem) {
                appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
              } else if (index == appThemeMode.themeModeLight) {
                appStore.setDarkMode(false);
              } else if (index == appThemeMode.themeModeDark) {
                appStore.setDarkMode(true);
              }
              setValue(THEME_MODE_INDEX, index);
              setState(() {});
              LiveStream().emit('UpdateTheme');
              finish(context);
            });
          },
        ),
      ),
    );
  }
}

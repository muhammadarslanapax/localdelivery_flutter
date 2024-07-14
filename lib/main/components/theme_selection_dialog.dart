import 'package:flutter/material.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../utils/Constants.dart';

class ThemeSelectionDialog extends StatefulWidget {
  static String tag = '/ThemeSelectionDialog';

  @override
  ThemeSelectionDialogState createState() => ThemeSelectionDialogState();
}

class ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
    print(currentIndex.toString());
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
    return Container(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            decoration: boxDecorationWithShadow(backgroundColor: colorPrimary, borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.theme, style: boldTextStyle(size: 20, color: Colors.white)).paddingLeft(12),
                CloseButton(color: Colors.white),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            children: List.generate(
              ThemeModes.values.length,
              (index) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    listTileTheme: ListTileThemeData(
                      horizontalTitleGap: 2,//here adjust based on your need
                    ),
                  ),
                  child: RadioListTile(
                    value: index,
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    groupValue: currentIndex,

                    activeColor: colorPrimary,
                    title: Text('${_getName(ThemeModes.values[index])}', style: primaryTextStyle()),
                    onChanged: (dynamic val) {
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
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

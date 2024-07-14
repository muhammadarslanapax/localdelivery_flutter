import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main.dart';
import '../components/CommonScaffoldComponent.dart';

class LanguageScreen extends StatefulWidget {
  static String tag = '/LanguageScreen';

  @override
  LanguageScreenState createState() => LanguageScreenState();
}

class LanguageScreenState extends State<LanguageScreen> {
  int? currentIndex = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: language.language,
      body: AnimatedScrollView(
        padding: EdgeInsets.all(8),
        children: List.generate(localeLanguageList.length, (index) {
          LanguageDataModel data = localeLanguageList[index];
          return Container(
            margin: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor: Colors.transparent,
                border: Border.all(color: getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage) == data.languageCode ? colorPrimary : dividerColor)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Image.asset(data.flag.validate(), width: 34, height: 34).cornerRadiusWithClipRRect(4),
                8.width,
                Text('${data.name.validate()}', style: primaryTextStyle()).expand(),
                getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage) == data.languageCode
                    ? Icon(Ionicons.radio_button_on, size: 20, color: colorPrimary)
                    : Icon(Ionicons.radio_button_off_sharp, size: 20, color: dividerColor),
              ],
            ),
          ).onTap(() async {
            await setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
            selectedLanguageDataModel = data;
            appStore.setLanguage(data.languageCode!, context: context);
            setState(() {});
            LiveStream().emit('UpdateLanguage');
            finish(context);
          }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
        }),
      ),
    );
  }
}

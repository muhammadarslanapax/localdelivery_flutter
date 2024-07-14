import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Constants.dart';
import '../utils/Common.dart';
import '../utils/Widgets.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(language.aboutUs),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text(language.appName, style: boldTextStyle(size: 20, letterSpacing: 0.5)),
          8.height,
          Text(language.mAppDescription, style: secondaryTextStyle(), textAlign: TextAlign.start),
          30.height,
          Text(language.contactUs, style: primaryTextStyle(size: 14), textAlign: TextAlign.justify),
          4.height,
          GestureDetector(
            onTap: () async {
              commonLaunchUrl('mailto:$mContactPref');
            },
            child: Text(mContactPref, style: primaryTextStyle(color: colorPrimary)),
          ),
        ],
      ).center().paddingAll(16),
      bottomNavigationBar: Text(mCopyright, style: secondaryTextStyle(size: 12), textAlign: TextAlign.center).paddingAll(10),
    );
  }
}

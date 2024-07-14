import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../main.dart';
import '../../main/components/theme_selection_dialog.dart';
import '../../main/network/RestApis.dart';
import '../../main/screens/AboutUsScreen.dart';
import '../../main/screens/BankDetailScreen.dart';
import '../../main/screens/ChangePasswordScreen.dart';
import '../../main/screens/EditProfileScreen.dart';
import '../../main/screens/LanguageScreen.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import '../../main/utils/Images.dart';
import '../../user/screens/DraftOrderListScreen.dart';
import '../../user/screens/WalletScreen.dart';
import '../screens/DeleteAccountScreen.dart';
import '../screens/MyAddressListScreen.dart';

class AccountFragment extends StatefulWidget {
  static String tag = '/AccountFragment';

  @override
  AccountFragmentState createState() => AccountFragmentState();
}

class AccountFragmentState extends State<AccountFragment> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget accountSettingItemWidget(String? img, String title, Function() onTap, {bool isLast = false, IconData? suffixIcon}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            minLeadingWidth: 14,
            dense: true,
            leading: Image.asset(img.validate(), height: 18, fit: BoxFit.fill, width: 18, color: textPrimaryColorGlobal),
            title: Text(title, style: primaryTextStyle()),
            trailing: suffixIcon != null ? Icon(suffixIcon, color: Colors.green) : Icon(Icons.navigate_next, color: appStore.isDarkMode ? Colors.white : Colors.grey),
            onTap: onTap),
        if (isLast) Divider(height: 0, color: context.dividerColor)
      ],
    );
  }

  Widget mTitle(String value) {
    return Text(value.toUpperCase(), style: boldTextStyle(size: 12, letterSpacing: 0.7, color: textSecondaryColorGlobal)).paddingOnly(left: 16, right: 16, top: 24, bottom: 4);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AnimatedScrollView(
        fadeInConfiguration: FadeInConfiguration(duration: Duration(seconds: 1)),
        padding: EdgeInsets.only(bottom: context.height() * 0.1, top: 16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(width: 2, color: colorPrimary)),
                          child: commonCachedNetworkImage(appStore.userProfile.validate(), height: 65, width: 65, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(50)),
                      Container(
                        decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(width: 1, color: white), backgroundColor: colorPrimary),
                        padding: EdgeInsets.all(4),
                        child: Image.asset(ic_edit, color: white, height: 14, width: 14),
                      )
                    ],
                  ),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getStringAsync(NAME).validate(), style: boldTextStyle(size: 20)),
                      6.height,
                      Text(appStore.userEmail.validate(), style: secondaryTextStyle(size: 16)),
                    ],
                  )
                ],
              ).paddingSymmetric(horizontal: 16).onTap(() {
                EditProfileScreen().launch(context);
              }),
              mTitle(language.ordersWalletMore),
              accountSettingItemWidget(ic_draft, language.drafts, () {
                DraftOrderListScreen().launch(context);
              }),
              accountSettingItemWidget(ic_wallet, language.wallet, () {
                WalletScreen().launch(context);
              }),
              accountSettingItemWidget(
                ic_bank_detail,
                language.bankDetails,
                () {
                  BankDetailScreen().launch(context);
                },
              ),
              accountSettingItemWidget(ic_bank_detail, language.lblMyAddresses, () {
                MyAddressListScreen().launch(context);
              }, isLast: true),
              mTitle(language.account),
              accountSettingItemWidget(ic_change_password, language.changePassword, () {
                ChangePasswordScreen().launch(context);
              }),
              accountSettingItemWidget(ic_languages, language.language, () {
                LanguageScreen().launch(context);
              }),
              accountSettingItemWidget(ic_dark_mode, language.theme, () async {
                await showInDialog(context, shape: RoundedRectangleBorder(borderRadius: radius()), builder: (_) => ThemeSelectionDialog(), contentPadding: EdgeInsets.zero);
              }),
              accountSettingItemWidget(ic_delete_account, language.deleteAccount, () async {
                DeleteAccountScreen().launch(context);
              }, isLast: true),
              mTitle(language.general),
              accountSettingItemWidget(ic_document, language.privacyPolicy, () {
                commonLaunchUrl(mPrivacyPolicy);
              }),
              accountSettingItemWidget(ic_information, language.helpAndSupport, () {
                commonLaunchUrl(mHelpAndSupport);
              }),
              accountSettingItemWidget(ic_document, language.termAndCondition, () {
                commonLaunchUrl(mTermAndCondition);
              }),
              accountSettingItemWidget(ic_information, language.aboutUs, () {
                AboutUsScreen().launch(context);
              }, isLast: false),
              Container(
                decoration: boxDecorationWithRoundedCorners(border: Border.all(color: colorPrimary, width: 1), backgroundColor: Colors.transparent),
                padding: EdgeInsets.all(16),
                width: context.width(),
                child: Text(language.logout, style: boldTextStyle(size: 18, color: colorPrimary), textAlign: TextAlign.center),
              ).onTap(() async {
                await showConfirmDialogCustom(
                  context,
                  primaryColor: colorPrimary,
                  title: language.logoutConfirmationMsg,
                  positiveText: language.yes,
                  negativeText: language.no,
                  onAccept: (c) {
                    logout(context);
                  },
                );
              }).paddingAll(16),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Text('${language.version} ${snap.data!.version.validate()}', style: secondaryTextStyle()).center();
                  }
                  return SizedBox();
                },
              ),
              30.height,
            ],
          ),
        ],
      ),
    );
  }
}

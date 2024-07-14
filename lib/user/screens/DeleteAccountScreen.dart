import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import '../../main.dart';
import '../../main/components/BodyCornerWidget.dart';
import '../../main/components/CommonScaffoldComponent.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main/services/AuthServices.dart';
import '../../main/network/RestApis.dart';
import '../../main/utils/Constants.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  DeleteAccountScreenState createState() => DeleteAccountScreenState();
}

class DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future deleteAccount(BuildContext context) async {
    Map req = {"id": getIntAsync(USER_ID)};
    appStore.setLoading(true);
    await deleteUser(req).then((value) async {
      await userService.removeDocument(getStringAsync(UID)).then((value) async {
        await deleteUserFirebase().then((value) async {
          await logout(context, isDeleteAccount: true).then((value) async {
            appStore.setLoading(false);
            await removeKey(USER_EMAIL);
            await removeKey(USER_PASSWORD);
          });
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: language.deleteAccount,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language.confirmAccountDeletion, style: boldTextStyle(size: 18)),
                Divider(color: context.dividerColor),
                8.height,
                Text(language.deleteAccountMsg2, style: primaryTextStyle()),
                24.height,
              ],
            ),
          ),
          Observer(builder: (context) {
            return loaderWidget().visible(appStore.isLoading);
          }),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          commonButton(
              language.deleteAccount,
              () async => {
                    await showConfirmDialogCustom(
                      context,
                      title: language.deleteAccountConfirmMsg,
                      dialogType: DialogType.DELETE,
                      positiveText: language.yes,
                      negativeText: language.no,
                      onAccept: (c) async {
                        if (getStringAsync(USER_EMAIL) == 'jose@gmail.com' || getStringAsync(USER_EMAIL) == 'mark@gmail.com') {
                          toast(language.demoMsg);
                        } else {
                          await deleteAccount(context);
                        }
                      },
                    ),
                  },
              width: context.width(),
              color: Colors.red,
              textColor: Colors.white),
        ],
      ).paddingAll(16),
    );
  }
}

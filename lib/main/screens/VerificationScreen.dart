import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_delivery/main/components/CommonScaffoldComponent.dart';
import 'package:mighty_delivery/main/services/AuthServices.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:mighty_delivery/user/screens/DashboardScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:otp_text_field/style.dart';
import '../../delivery/screens/DeliveryDashBoard.dart';
import 'package:otp_text_field/otp_field.dart' as otp;
import 'package:otp_text_field/otp_field_style.dart' as o;

import '../../main.dart';
import '../models/CityListModel.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import 'UserCitySelectScreen.dart';

class VerificationScreen extends StatefulWidget {
  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  bool? isOtpSend = false;
  String verId = '';
  String? otpPin = '';

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: language.verification,
      showBack: false,
      action: [
        IconButton(
          onPressed: () async {
            await showConfirmDialogCustom(
              context,
              primaryColor: colorPrimary,
              title: language.logoutConfirmationMsg,
              positiveText: language.yes,
              negativeText: language.no,
              onAccept: (c) {
                logout(context, isVerification: true);
              },
            );
          },
          icon: Icon(Icons.logout,color: Colors.white),
        ),
      ],
      body: Stack(
        children: [
          isOtpSend == false
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      16.height,
                      Text(language.phoneNumberVerification, style: boldTextStyle(size: 18)),
                      16.height,
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: secondaryTextStyle(),
                          children: [
                            TextSpan(text: '${language.weSend} '),
                            TextSpan(text: language.oneTimePassword, style: boldTextStyle()),
                            TextSpan(text: " ${language.on} " + getStringAsync(USER_CONTACT_NUMBER).replaceAll(RegExp(r'(?<=.*).(?=.{2})'), '*') ?? "-")
                          ],
                        ),
                      ),
                      16.height,
                      commonButton(language.getOTP, () {
                        // isOtpSend = true;
                        sendOtp(context, phoneNumber: getStringAsync(USER_CONTACT_NUMBER), onUpdate: (verificationId) {
                          verId = verificationId;
                          isOtpSend = true;
                          setState(() {});
                        });
                        setState(() {});
                      }, width: context.width())
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      16.height,
                      Text(language.confirmationCode, style: boldTextStyle(size: 18)),
                      16.height,
                      Text("${language.confirmationCodeSent} " + getStringAsync(USER_CONTACT_NUMBER).replaceAll(RegExp(r'(?<=.*).(?=.{2})'), '*') ?? "-",
                          style: secondaryTextStyle(size: 16), textAlign: TextAlign.center),
                      30.height,
                      otp.OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 35,
                        otpFieldStyle: o.OtpFieldStyle(borderColor: context.dividerColor, focusBorderColor: colorPrimary),
                        style: primaryTextStyle(),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onChanged: (s) {
                          //
                        },
                        onCompleted: (pin) async {
                          otpPin = pin;
                          setState(() {});
                        },
                      ),
                      30.height,
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(language.didNotReceiveTheCode, style: secondaryTextStyle(size: 16)),
                          4.width,
                          Text(language.resend, style: boldTextStyle(color: colorPrimary)).onTap(() {
                            sendOtp(context, phoneNumber: getStringAsync(USER_CONTACT_NUMBER).validate(), onUpdate: (verificationId) {
                              verId = verificationId;
                              setState(() {});
                            });
                          }),
                        ],
                      ),
                      16.height,
                      commonButton(language.submit, () async {
                        appStore.setLoading(true);
                        AuthCredential credential = PhoneAuthProvider.credential(verificationId: verId, smsCode: otpPin.validate());
                        await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                          appStore.setLoading(false);
                          updateUserStatus({"id": getIntAsync(USER_ID), "otp_verify_at": DateTime.now().toString()}).then((value) {
                            setValue(OTP_VERIFIED, true);
                            if (CityModel.fromJson(getJSONAsync(CITY_DATA)).name.validate().isNotEmpty) {
                              if (getStringAsync(USER_TYPE) == CLIENT) {
                                DashboardScreen().launch(context, isNewTask: true);
                              } else {
                                DeliveryDashBoard().launch(context, isNewTask: true);
                              }
                            } else {
                              UserCitySelectScreen().launch(context, isNewTask: true);
                            }
                          });
                        }).catchError((error) {
                          appStore.setLoading(false);
                          toast(language.invalidVerificationCode);
                          finish(context);
                        });
                        setState(() {});
                      }, width: context.width())
                    ],
                  ),
                ),
          Observer(builder: (context) => Visibility(visible: appStore.isLoading, child: Positioned.fill(child: loaderWidget()))),
        ],
      ),
    );
  }
}

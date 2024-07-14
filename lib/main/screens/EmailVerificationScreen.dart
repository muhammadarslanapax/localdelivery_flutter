import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_delivery/main/components/CommonScaffoldComponent.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:mighty_delivery/user/screens/DashboardScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:otp_text_field/otp_field.dart' as otp;
import 'package:otp_text_field/otp_field_style.dart' as o;
import 'package:otp_text_field/style.dart';

import '../../main.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import 'LoginScreen.dart';
import 'UserCitySelectScreen.dart';
import 'VerificationScreen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final bool? isSignIn;
  final bool? isSignUp;

  EmailVerificationScreen({this.isSignIn = false, this.isSignUp = false});

  @override
  EmailVerificationScreenState createState() => EmailVerificationScreenState();
}

class EmailVerificationScreenState extends State<EmailVerificationScreen> {
  otp.OtpFieldController otpController = otp.OtpFieldController();

  bool? isEmailSend = false;
  String verId = '';
  String? otpPin = '';

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  userDetailGet() async {
    await getUserDetail(getIntAsync(USER_ID)).then((value) async {
      appStore.setLoading(false);
      setValue(OTP_VERIFIED, value.otpVerifyAt != null);
      setState(() {});
      if (getBoolAsync(OTP_VERIFIED).validate()) {
        DashboardScreen().launch(context, isNewTask: true);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  verifyOtpEmailApiCall(pin) async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await verifyOtpEmail({"code": pin}).then((value) async {
      setValue(EMAIL_VERIFIED, true);
      toast(value.message.toString());
      if (widget.isSignUp == true) {
        toast(language.userNotApproveMsg);
        LoginScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      } else {
        if (!getBoolAsync(OTP_VERIFIED)) {
          VerificationScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
        } else {
          UserCitySelectScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
        }
      }
      appStore.setLoading(false);
    }).catchError((e) {
      otpController.clear();
      hideKeyboard(context);
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  resendOtpEmailApiCall() async {
    appStore.setLoading(true);
    await resendOtpEmail().then((value) {
      hideKeyboard(context);
      appStore.setLoading(false);
      toast(value.message.toString());
    }).catchError((e) {
      hideKeyboard(context);
      appStore.setLoading(false);
      toast(e['message']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return Future.delayed(Duration(seconds: 3), () {
          userDetailGet();
        });
      },
      child: CommonScaffoldComponent(
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
                onAccept: (c) async {
                  appStore.setLoading(true);
                  try {
                    await logout(context, isVerification: true).then((value) async {
                      appStore.setLoading(false);
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                },
              );
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
        body: Stack(
          children: [
            widget.isSignIn == true && isEmailSend == false
                ? Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        16.height,
                        Text(language.emailVerification, style: boldTextStyle(size: 18)),
                        16.height,
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: secondaryTextStyle(),
                            children: [
                              TextSpan(text: '${language.weSend} '),
                              TextSpan(text: language.oneTimePassword, style: boldTextStyle()),
                              TextSpan(text: " ${language.on} " + getStringAsync(USER_EMAIL).replaceAll(RegExp(r'(?<=.{3}).(?=.*@)'), '*') ?? "-")
                            ],
                          ),
                        ),
                        16.height,
                        commonButton(language.getEmail, () {
                          resendOtpEmailApiCall();
                          isEmailSend = true;
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
                        Text("${language.confirmationCodeSent} " + getStringAsync(USER_EMAIL).replaceAll(RegExp(r'(?<=.{3}).(?=.*@)'), '*') ?? "-",
                            style: secondaryTextStyle(size: 16), textAlign: TextAlign.center),
                        30.height,
                        otp.OTPTextField(
                          controller: otpController,
                          length: 5,
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
                              resendOtpEmailApiCall();
                            }),
                          ],
                        ),
                        16.height,
                        commonButton(language.submit, () async {
                          verifyOtpEmailApiCall(otpPin);
                        }, width: context.width())
                      ],
                    ),
                  ),
            Observer(builder: (context) => Visibility(visible: appStore.isLoading, child: Positioned.fill(child: loaderWidget()))),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_checker/store_checker.dart';

import '../../delivery/screens/DeliveryDashBoard.dart';
import '../../main.dart';
import '../../main/network/RestApis.dart';
import '../../main/screens/ForgotPasswordScreen.dart';
import '../../main/screens/RegisterScreen.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import '../../main/utils/Widgets.dart';
import '../../user/screens/DashboardScreen.dart';
import '../models/CityListModel.dart';
import '../services/AuthServices.dart';
import '../utils/Images.dart';
import 'EmailVerificationScreen.dart';
import 'UserCitySelectScreen.dart';
import 'VerificationScreen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  bool mIsCheck = false;

  bool isAcceptedTc = false;
  String userType = CLIENT;
  int? isDemoSelected;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (getStringAsync(PLAYER_ID).isEmpty) {
      await saveOneSignalPlayerId().then((value) {
        //
      });
    }
    mIsCheck = getBoolAsync(REMEMBER_ME, defaultValue: false);
    if (mIsCheck) {
      emailController.text = getStringAsync(USER_EMAIL);
      passController.text = getStringAsync(USER_PASSWORD);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> loginApiCall() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      if (isAcceptedTc) {
        appStore.setLoading(true);

        Map req = {
          "email": emailController.text,
          "password": passController.text,
          "player_id": getStringAsync(PLAYER_ID).validate(),
        };

        if (mIsCheck) {
          await setValue(REMEMBER_ME, mIsCheck);
          await setValue(USER_EMAIL, emailController.text);
          await setValue(USER_PASSWORD, passController.text);
        }
        await logInApi(req).then((v) async {
          authService.signInWithEmailPassword(context, email: emailController.text, password: passController.text).then((value) async {
            appStore.setLoading(false);

            if (v.data!.userType != CLIENT && v.data!.userType != DELIVERY_MAN) {
              await logout(context, isFromLogin: true);
            } else {
              appStore.setUserType(v.data!.userType.toString());
              if (getIntAsync(STATUS) == 1) {
                updateUserStatus({
                  "id": getIntAsync(USER_ID),
                  "uid": getStringAsync(UID),
                }).then((value) {
                  log("value...." + value.toString());
                });
                log("Email verify at :${v.isEmailVerification}");
                log('v.data!.emailVerifiedAt ${v.data!.emailVerifiedAt}');
                log('v.data!.otp ${v.data!.otpVerifyAt}');

                if (v.isEmailVerification == '1' && v.data!.emailVerifiedAt.isEmptyOrNull)
                  EmailVerificationScreen(isSignIn: true).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
                else if (v.data!.otpVerifyAt.isEmptyOrNull)
                  VerificationScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
                else {
                  if (v.data!.countryId != null && v.data!.cityId != null) {
                    await getCountryDetailApiCall(v.data!.countryId.validate());
                    getCityDetailApiCall(v.data!.cityId.validate());
                  } else {
                    UserCitySelectScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
                  }
                }
              } else {
                toast(language.userNotApproveMsg);
                await logout(context, isDeleteAccount: true);
              }
            }
            updateStoreCheckerData().then((source) async {
              await getUserDetail(getIntAsync(USER_ID)).then((value) async {
                if (value.app_source.isEmptyOrNull || value.app_source != source) {
                  await updateUserStatus({"id": getIntAsync(USER_ID), "app_source": source}).then((data) {});
                }
              }).catchError((e) {
                log(e);
              });
            });
          });
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      } else {
        toast(language.acceptTermService);
      }
    }
  }

  Future<String> updateStoreCheckerData() async {
    Source installationSource;
    try {
      installationSource = await StoreChecker.getSource;
    } on PlatformException {
      installationSource = Source.UNKNOWN;
    }

    // Set source text state
    switch (installationSource) {
      case Source.IS_INSTALLED_FROM_PLAY_STORE:
        return PLAY_STORE;
      case Source.IS_INSTALLED_FROM_PLAY_PACKAGE_INSTALLER:
        return GOOGLE_PACKAGE_INSTALLER;
      case Source.IS_INSTALLED_FROM_RU_STORE:
        return RUSTORE;
      case Source.IS_INSTALLED_FROM_LOCAL_SOURCE:
        return LOCAL_SOURCE;
      case Source.IS_INSTALLED_FROM_AMAZON_APP_STORE:
        return AMAZON_STORE;
      case Source.IS_INSTALLED_FROM_HUAWEI_APP_GALLERY:
        return HUAWEI_APP_GALLERY;
      case Source.IS_INSTALLED_FROM_SAMSUNG_GALAXY_STORE:
        return SAMSUNG_GALAXY_STORE;
      case Source.IS_INSTALLED_FROM_SAMSUNG_SMART_SWITCH_MOBILE:
        return SAMSUNG_SMART_SWITCH_MOBILE;
      case Source.IS_INSTALLED_FROM_XIAOMI_GET_APPS:
        return XIAOMI_GET_APPS;
      case Source.IS_INSTALLED_FROM_OPPO_APP_MARKET:
        return OPPO_APP_MARKET;
      case Source.IS_INSTALLED_FROM_VIVO_APP_STORE:
        return VIVO_APP_STORE;
      case Source.IS_INSTALLED_FROM_OTHER_SOURCE:
        return OTHER_SOURCE;
      case Source.IS_INSTALLED_FROM_APP_STORE:
        return APP_STORE;
      case Source.IS_INSTALLED_FROM_TEST_FLIGHT:
        return TEST_FLIGHT;
      case Source.UNKNOWN:
        return UNKNOWN_SOURCE;
    }
  }

  getCountryDetailApiCall(int countryId) async {
    await getCountryDetail(countryId).then((value) {
      setValue(COUNTRY_DATA, value.data!.toJson());
    }).catchError((error) {});
  }

  getCityDetailApiCall(int cityId) async {
    await getCityDetail(cityId).then((value) async {
      await setValue(CITY_DATA, value.data!.toJson());
      if (CityModel.fromJson(getJSONAsync(CITY_DATA)).name.validate().isNotEmpty) {
        if (getBoolAsync(OTP_VERIFIED)) {
          if (getStringAsync(USER_TYPE) == CLIENT) {
            DashboardScreen().launch(context, isNewTask: true);
          } else {
            DeliveryDashBoard().launch(context, isNewTask: true);
          }
        } else {
          VerificationScreen().launch(context, isNewTask: true);
        }
      } else {
        UserCitySelectScreen().launch(context, isNewTask: true);
      }
    }).catchError((error) {
      if (error.toString() == CITY_NOT_FOUND_EXCEPTION) {
        UserCitySelectScreen().launch(getContext, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }
    });
  }

  void googleSignIn() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    await authService.signInWithGoogle(userType: userType).then((value) async {
      appStore.setLoading(false);
      await setValue(USER_PASSWORD, passController.text);
      await setValue(LOGIN_TYPE, LoginTypeGoogle);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      print(e.toString());
    });
  }

  appleLoginApi() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await authService.appleLogIn(userType).then((value) {
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimaryLight,
      appBar: commonAppBarWidget(language.signIn, showBack: false),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Text(language.email, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    focus: emailFocus,
                    nextFocus: passFocus,
                    decoration: commonInputDecoration(),
                    errorThisFieldRequired: language.fieldRequiredMsg,
                    errorInvalidEmail: language.emailInvalid,
                  ),
                  16.height,
                  Text(language.password, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: passController,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: passFocus,
                    decoration: commonInputDecoration(),
                    errorThisFieldRequired: language.fieldRequiredMsg,
                    errorMinimumPasswordLength: language.passwordInvalid,
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: radius(4)),
                              checkColor: Colors.white,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              focusColor: colorPrimary,
                              activeColor: colorPrimary,
                              value: mIsCheck,
                              onChanged: (bool? value) async {
                                mIsCheck = value!;
                                if (!mIsCheck) {
                                  removeKey(REMEMBER_ME);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          10.width,
                          Text(language.rememberMe, style: primaryTextStyle())
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(language.forgotPasswordQue, style: primaryTextStyle()).onTap(() {
                          ForgotPasswordScreen().launch(context);
                        }),
                      ),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: radius(4)),
                          checkColor: Colors.white,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          focusColor: colorPrimary,
                          activeColor: colorPrimary,
                          value: isAcceptedTc,
                          onChanged: (bool? value) async {
                            isAcceptedTc = value!;
                            setState(() {});
                          },
                        ),
                      ),
                      10.width,
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(text: '${language.iAgreeToThe} ', style: secondaryTextStyle()),
                          TextSpan(
                            text: language.termOfService,
                            style: boldTextStyle(color: colorPrimary, size: 14),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                commonLaunchUrl(mTermAndCondition);
                              },
                          ),
                          TextSpan(text: ' & ', style: secondaryTextStyle()),
                          TextSpan(
                            text: language.privacyPolicy,
                            style: boldTextStyle(color: colorPrimary, size: 14),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                commonLaunchUrl(mPrivacyPolicy);
                              },
                          ),
                        ]),
                      ).expand()
                    ],
                  ),
                  30.height,
                  commonButton(
                    language.signIn,
                    () {
                      loginApiCall();
                    },
                    width: context.width(),
                  ),
                  16.height,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      OutlinedButton(
                        child: Text('Demo User', style: secondaryTextStyle(size: 16, color: isDemoSelected == 0 ? colorPrimary : textSecondaryColor)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: isDemoSelected == 0 ? 1 : 0.5, color: isDemoSelected == 0 ? colorPrimary : textSecondaryColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          isDemoSelected = 0;
                          emailController.text = 'mark@gmail.com';
                          passController.text = '123456';
                          setState(() { });
                        },
                      ).expand(),
                      16.width,
                      OutlinedButton(
                        child: Text('Demo Delivery Man', style: secondaryTextStyle(size: 16, color: isDemoSelected == 1 ? colorPrimary : textSecondaryColor)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: isDemoSelected == 1 ? 1 : 0.5, color: isDemoSelected == 1 ? colorPrimary : textSecondaryColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          isDemoSelected = 1;
                          emailController.text = 'jose@gmail.com';
                          passController.text = '123456';
                          setState(() { });
                        },
                      ).expand(),
                    ],
                  ),
                  32.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(language.doNotHaveAccount, style: primaryTextStyle()),
                      4.width,
                      Text(language.signUp, style: boldTextStyle(color: colorPrimary)).onTap(() {
                        RegisterScreen(
                          userType: CLIENT,
                        ).launch(context, duration: Duration(milliseconds: 500), pageRouteAnimation: PageRouteAnimation.Slide);
                      }),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Spacer(),
                      Divider().expand(),
                      16.width,
                      Text(language.signWith, style: secondaryTextStyle()),
                      16.width,
                      Divider().expand(),
                      Spacer(),
                    ],
                  ),
                  20.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        child: Image.asset(ic_google, height: 30, width: 30),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          socialDialog(() {
                            googleSignIn();
                          });
                        },
                      ),
                      if (isIOS) 8.width,
                      if (isIOS)
                        OutlinedButton(
                          child: Image.asset(ic_apple, height: 30, width: 30),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            socialDialog(() {
                              appleLoginApi();
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Observer(builder: (context) => loaderWidget().visible(appStore.isLoading)),
        ],
      ),
      bottomNavigationBar: Container(
        color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimaryLight,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${language.becomeADeliveryBoy} ?", style: primaryTextStyle()),
            4.width,
            Text(language.signUp, style: boldTextStyle(color: colorPrimary)).onTap(() {
              RegisterScreen(userType: DELIVERY_MAN).launch(context, duration: Duration(milliseconds: 500), pageRouteAnimation: PageRouteAnimation.Slide);
            }),
          ],
        ),
      ),
    );
  }

  socialDialog(Function onContinue) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actionsPadding: EdgeInsets.all(16),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
              title: Padding(padding: EdgeInsets.only(bottom: 10), child: Text(language.selectUserType, style: boldTextStyle(size: 18))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: userTypeList.map((item) {
                  return RadioListTile<String>(
                    value: item,
                    activeColor: colorPrimary,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    title: Text('${item == CLIENT ? language.lblUser : item == DELIVERY_MAN ? language.lblDeliveryBoy : ''}'),
                    groupValue: userType,
                    onChanged: (val) {
                      userType = val.validate();
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    outlineButton(language.cancel, () {
                      Navigator.pop(context);
                    }).expand(),
                    16.width,
                    commonButton(language.lblContinue, () {
                      finish(context);
                      onContinue();
                    }, color: colorPrimary)
                        .expand(),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

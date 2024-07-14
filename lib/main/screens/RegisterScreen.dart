import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import '../../main/utils/Widgets.dart';
import '../components/CommonScaffoldComponent.dart';
import '../network/RestApis.dart';
import '../services/AuthServices.dart';

class RegisterScreen extends StatefulWidget {
  final String? userType;
  static String tag = '/RegisterScreen';

  RegisterScreen({this.userType});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();
  String countryCode = defaultPhoneCode;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  bool isAcceptedTc = false;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> registerApiCall() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      if (isAcceptedTc) {
        appStore.setLoading(true);
        var request = {
          "name": nameController.text,
          "username": emailController.text,
          "user_type": widget.userType,
          "contact_number": '$countryCode ${phoneController.text.trim()}',
          "email": emailController.text.trim(),
          "password": passController.text.trim(),
          "player_id": getStringAsync(PLAYER_ID).validate(),
          if (widget.userType == DELIVERY_MAN) "status": 1
        };
        await signUpApi(request).then((res) async {
          await setValue(USER_TOKEN, res.data!.apiToken.validate());
          authService
              .signUpWithEmailPassword(getContext,
                  lName: res.data!.name,
                  userName: res.data!.username,
                  name: res.data!.name,
                  email: res.data!.email,
                  password: passController.text.trim(),
                  mobileNumber: res.data!.contactNumber,
                  userType: res.data!.userType,
                  userData: res)
              .then((res) async {
            //
          }).catchError((e) {
            appStore.setLoading(false);
            log(e.toString());
            toast(e.toString());
          });
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
          log(e.toString());
          return;
        });
      } else {
        toast(language.acceptTermService);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: language.signUp,
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
                  Text(language.name, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: nameController,
                    textFieldType: TextFieldType.NAME,
                    focus: nameFocus,
                    nextFocus: emailFocus,
                    decoration: commonInputDecoration(),
                    errorThisFieldRequired: language.fieldRequiredMsg,
                  ),
                  16.height,
                  Text(language.email, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                      controller: emailController,
                      textFieldType: TextFieldType.EMAIL,
                      focus: emailFocus,
                      nextFocus: phoneFocus,
                      decoration: commonInputDecoration(),
                      errorThisFieldRequired: language.fieldRequiredMsg,
                      errorInvalidEmail: language.emailInvalid),
                  16.height,
                  Text(language.contactNumber, style: primaryTextStyle()),
                  8.height,
                  AppTextField(
                    controller: phoneController,
                    textFieldType: TextFieldType.PHONE,
                    focus: phoneFocus,
                    nextFocus: passFocus,
                    decoration: commonInputDecoration(
                      prefixIcon: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CountryCodePicker(
                              initialSelection: countryCode,
                              showCountryOnly: false,
                              dialogSize: Size(context.width() - 60, context.height() * 0.6),
                              showFlag: true,
                              showFlagDialog: true,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              textStyle: primaryTextStyle(),
                              dialogBackgroundColor: Theme.of(context).cardColor,
                              barrierColor: Colors.black12,
                              dialogTextStyle: primaryTextStyle(),
                              searchDecoration: InputDecoration(
                                iconColor: Theme.of(context).dividerColor,
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                              ),
                              searchStyle: primaryTextStyle(),
                              onInit: (c) {
                                countryCode = c!.dialCode!;
                              },
                              onChanged: (c) {
                                countryCode = c.dialCode!;
                              },
                            ),
                            VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) return language.fieldRequiredMsg;
                      // if (value.trim().length < minContactLength || value.trim().length > maxContactLength) return language.contactLength;
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: radius(4)),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          focusColor: colorPrimary,
                          activeColor: colorPrimary,
                          checkColor: Colors.white,
                          value: isAcceptedTc,
                          onChanged: (bool? value) async {
                            isAcceptedTc = value!;
                            setState(() {});
                          },
                        ),
                      ),
                      16.width,
                      RichTextWidget(
                        list: [
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
                        ],
                      ).expand()
                    ],
                  ),
                  30.height,
                  commonButton(language.signUp, () {
                    registerApiCall();
                  }, width: context.width()),
                  30.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(language.alreadyHaveAnAccount, style: primaryTextStyle()),
                      4.width,
                      Text(language.signIn, style: boldTextStyle(color: colorPrimary)).onTap(() {
                        finish(context);
                      }),
                    ],
                  ),
                  16.height,
                ],
              ),
            ),
          ),
          Observer(builder: (context) => loaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}

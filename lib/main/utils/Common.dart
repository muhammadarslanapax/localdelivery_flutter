import 'dart:core';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Constants.dart';
import '../../user/screens/OrderDetailScreen.dart';
import '../Chat/ChatScreen.dart';
import '../models/LoginResponse.dart';
import '../network/RestApis.dart';
import '../screens/LoginScreen.dart';
import '../services/AuthServices.dart';
import 'Images.dart';
import 'Widgets.dart';

InputDecoration commonInputDecoration({String? hintText, IconData? suffixIcon, Function()? suffixOnTap, Widget? dateTime, Widget? prefixIcon, bool? isFill = true}) {
  return InputDecoration(
    errorMaxLines: 3,
    contentPadding: EdgeInsets.all(16),
    filled: true,
    prefixIcon: prefixIcon,
    isDense: true,
    hintText: hintText != null ? hintText : '',
    hintStyle: secondaryTextStyle(size: 16, color: Colors.grey),
    fillColor: colorPrimary.withOpacity(0.06),
    counterText: '',
    suffixIcon: dateTime != null
        ? dateTime
        : suffixIcon != null
            ? Icon(suffixIcon, color: colorPrimary, size: 22).onTap(suffixOnTap)
            : null,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, color: colorPrimaryLight), borderRadius: BorderRadius.circular(defaultRadius)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary), borderRadius: BorderRadius.circular(defaultRadius)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(defaultRadius)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(defaultRadius)),
  );
}

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      color: color,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('assets/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Color statusColor(String status) {
  Color color = colorPrimary;
  switch (status) {
    case ORDER_ACCEPTED:
      return acceptColor;
    case ORDER_CREATED:
      return CreatedColorColor;
    case ORDER_DEPARTED:
      return acceptColor;
    case ORDER_ASSIGNED:
      return pendingApprovalColorColor;
    case ORDER_PICKED_UP:
      return in_progressColor;
    case ORDER_ARRIVED:
      return in_progressColor;
    case ORDER_CANCELLED:
      return cancelledColor;
    case ORDER_DELIVERED:
      return completedColor;
    case ORDER_DRAFT:
      return holdColor;
    case ORDER_DELAYED:
      return WaitingStatusColor;
  }
  return color;
}

Color paymentStatusColor(String status) {
  Color color = colorPrimary;
  if (status == PAYMENT_PAID) {
    color = Colors.green;
  } else if (status == PAYMENT_FAILED) {
    color = Colors.red;
  } else if (status == PAYMENT_PENDING) {
    color = colorPrimary;
  }
  return color;
}

String parcelTypeIcon(String? parcelType) {
  String icon = 'assets/icons/ic_product.png';
  switch (parcelType.validate().toLowerCase()) {
    case "documents":
      return 'assets/icons/ic_document.png';
    case "document":
      return 'assets/icons/ic_document.png';
    case "food":
      return 'assets/icons/ic_food.png';
    case "foods":
      return 'assets/icons/ic_food.png';
    case "cake":
      return 'assets/icons/ic_cake.png';
    case "flowers":
      return 'assets/icons/ic_flower.png';
    case "flower":
      return 'assets/icons/ic_flower.png';
  }
  return icon;
}

String printDate(String date) {
  return DateFormat('dd MMM yyyy').format(DateTime.parse(date).toLocal()) + " at " + DateFormat('hh:mm a').format(DateTime.parse(date).toLocal());
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return (12742 * asin(sqrt(a))).toStringAsFixed(digitAfterDecimal).toDouble();
}

Widget loaderWidget() {
  return Center(child: Lottie.asset('assets/loader.json', width: 50, height: 70));
}

Widget emptyWidget() {
  return Center(child: Lottie.asset('assets/no_data.json', width: 150, height: 250));
}

String orderStatus(String orderStatus) {
  if (orderStatus == ORDER_ASSIGNED) {
    return language.assigned;
  } else if (orderStatus == ORDER_DRAFT) {
    return language.draft;
  } else if (orderStatus == ORDER_CREATED) {
    return language.created;
  } else if (orderStatus == ORDER_ACCEPTED) {
    return language.accepted;
  } else if (orderStatus == ORDER_PICKED_UP) {
    return language.pickedUp;
  } else if (orderStatus == ORDER_ARRIVED) {
    return language.arrived;
  } else if (orderStatus == ORDER_DEPARTED) {
    return language.departed;
  } else if (orderStatus == ORDER_DELIVERED) {
    return language.delivered;
  } else if (orderStatus == ORDER_CANCELLED) {
    return language.cancelled;
  }
  return language.assigned;
}

String transactionType(String type) {
  if (type == TRANSACTION_ORDER_FEE) {
    return language.orderFee;
  } else if (type == TRANSACTION_TOPUP) {
    return language.topup;
  } else if (type == TRANSACTION_ORDER_CANCEL_CHARGE) {
    return language.orderCancelCharge;
  } else if (type == TRANSACTION_ORDER_CANCEL_REFUND) {
    return language.orderCancelRefund;
  } else if (type == TRANSACTION_CORRECTION) {
    return language.correction;
  } else if (type == TRANSACTION_COMMISSION) {
    return language.commission;
  } else if (type == TRANSACTION_WITHDRAW) {
    return language.withdraw;
  }
  return '';
}

Future<bool> checkPermission() async {
  // Request app level location permission
  LocationPermission locationPermission = await Geolocator.requestPermission();

  if (locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
    // Check system level location permission
    if (!await Geolocator.isLocationServiceEnabled()) {
      return await Geolocator.openLocationSettings().then((value) => false).catchError((e) => false);
    } else {
      return true;
    }
  } else {
    toast(language.allowLocationPermission);

    // Open system level location permission
    await Geolocator.openAppSettings();

    return false;
  }
}

oneSignalSettings() async {
  if (isMobile) {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(false);
    OneSignal.initialize(mOneSignalAppId);
    OneSignal.Notifications.requestPermission(true);
    saveOneSignalPlayerId();
    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });
    OneSignal.Notifications.addClickListener((notification) async {
      var notId = notification.notification.additionalData!["id"];
      if (notId != null) {
        if (!appStore.isLoggedIn) {
          LoginScreen().launch(getContext);
        } else if (notId.toString().contains('CHAT')) {
          UserData user = await getUserDetail(int.parse(notId.toString().replaceAll("CHAT_", "")));
          ChatScreen(userData: user).launch(getContext);
        } else {
          OrderDetailScreen(orderId: int.parse(notId.toString())).launch(getContext);
        }
      }
    });
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
      event.preventDefault();
      event.notification.display();
    });
  }
}

Future<void> saveOneSignalPlayerId() async {
  OneSignal.User.pushSubscription.addObserver((state) async {
    print(OneSignal.User.pushSubscription.optedIn);
    print("Player Id" + OneSignal.User.pushSubscription.id.toString());
    print(OneSignal.User.pushSubscription.token);
    print(state.current.jsonRepresentation());

    if (OneSignal.User.pushSubscription.id.validate().isNotEmpty) await setValue(PLAYER_ID, OneSignal.User.pushSubscription.id.validate());
  });
}

String statusTypeIcon({String? type}) {
  String icon = ic_order;
  if (type == ORDER_ASSIGNED) {
    icon = ic_order_assigned;
  } else if (type == ORDER_ACCEPTED) {
    icon = ic_order_accept;
  } else if (type == ORDER_PICKED_UP) {
    icon = ic_order_pickedUp;
  } else if (type == ORDER_ARRIVED) {
    icon = ic_order_arrived;
  } else if (type == ORDER_DEPARTED) {
    icon = ic_order_departed;
  } else if (type == ORDER_DELIVERED) {
    icon = ic_order_delivered;
  } else if (type == ORDER_CANCELLED) {
    icon = ic_order_cancelled;
  } else if (type == ORDER_CREATED) {
    icon = ic_order_created;
  } else if (type == ORDER_DRAFT) {
    icon = ic_order_draft;
  } else if (type == ORDER_TRANSFER) {
    icon = ic_order_transfer;
  }
  return icon;
}

String? orderTitle(String orderStatus) {
  if (orderStatus == ORDER_ASSIGNED) {
    return language.orderAssignConfirmation;
  } else if (orderStatus == ORDER_ACCEPTED) {
    return language.orderPickupConfirmation;
  } else if (orderStatus == ORDER_PICKED_UP) {
    return language.orderDepartedConfirmation;
  } else if (orderStatus == ORDER_ARRIVED) {
    return language.orderPickupConfirmation;
  } else if (orderStatus == ORDER_DEPARTED) {
    return language.orderCompleteConfirmation;
  } else if (orderStatus == ORDER_DELIVERED) {
    return '';
  } else if (orderStatus == ORDER_CANCELLED) {
    return language.orderCancelConfirmation;
  } else if (orderStatus == ORDER_CREATED) {
    return language.orderCreateConfirmation;
  }
  return '';
}

// String historyStatus(String orderStatus) {
//   if (orderStatus == ORDER_ASSIGNED) {
//     return language.courierAssigned;
//   } else if (orderStatus == ORDER_CREATED) {
//     return language.created;
//   } else if (orderStatus == ORDER_ACCEPTED) {
//     return language.courierAccepted;
//   } else if (orderStatus == ORDER_PICKED_UP) {
//     return language.courierPickedUp;
//   } else if (orderStatus == ORDER_ARRIVED) {
//     return language.courierArrived;
//   } else if (orderStatus == ORDER_DEPARTED) {
//     return language.courierDeparted;
//   } else if (orderStatus == ORDER_DELIVERED) {
//     return language.completed;
//   } else if (orderStatus == ORDER_CANCELLED) {
//     return language.cancelled;
//   } else if (orderStatus == ORDER_TRANSFER) {
//     return language.courierTransfer;
//   } else if (orderStatus == ORDER_PAYMENT) {
//     return language.paymentStatusMessage;
//   }
//   return language.assigned;
// }

String dateParse(String date) {
  return DateFormat.yMd().add_jm().format(DateTime.parse(date).toLocal());
}

bool get isRTL => rtlLanguage.contains(appStore.selectedLanguage);

num countExtraCharge({required num totalAmount, required String chargesType, required num charges}) {
  if (chargesType == CHARGE_TYPE_PERCENTAGE) {
    return (totalAmount * charges * 0.01).toStringAsFixed(digitAfterDecimal).toDouble();
  } else {
    return charges.toStringAsFixed(digitAfterDecimal).toDouble();
  }
}

String paymentStatus(String paymentStatus) {
  if (paymentStatus.toLowerCase() == PAYMENT_PENDING.toLowerCase()) {
    return language.pending;
  } else if (paymentStatus.toLowerCase() == PAYMENT_FAILED.toLowerCase()) {
    return language.failed;
  } else if (paymentStatus.toLowerCase() == PAYMENT_PAID.toLowerCase()) {
    return language.paid;
  }
  return language.pending;
}

String? paymentCollectForm(String paymentType) {
  if (paymentType.toLowerCase() == PAYMENT_ON_PICKUP.toLowerCase()) {
    return language.onPickup;
  } else if (paymentType.toLowerCase() == PAYMENT_ON_DELIVERY.toLowerCase()) {
    return language.onDelivery;
  }
  return language.onPickup;
}

String paymentType(String paymentType) {
  if (paymentType.toLowerCase() == PAYMENT_TYPE_STRIPE.toLowerCase()) {
    return language.stripe;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_RAZORPAY.toLowerCase()) {
    return language.razorpay;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_PAYSTACK.toLowerCase()) {
    return language.payStack;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_FLUTTERWAVE.toLowerCase()) {
    return language.flutterWave;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_MERCADOPAGO.toLowerCase()) {
    return language.mercadoPago;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_PAYPAL.toLowerCase()) {
    return language.paypal;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_PAYTABS.toLowerCase()) {
    return language.payTabs;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_PAYTM.toLowerCase()) {
    return language.paytm;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_MYFATOORAH.toLowerCase()) {
    return language.myFatoorah;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_CASH.toLowerCase()) {
    return language.cash;
  } else if (paymentType.toLowerCase() == PAYMENT_TYPE_WALLET.toLowerCase()) {
    return language.wallet;
  }
  return language.cash;
}

String printAmount(var amount) {
  return appStore.currencyPosition == CURRENCY_POSITION_LEFT
      ? '${appStore.currencySymbol} ${amount.toStringAsFixed(digitAfterDecimal)}'
      : '${amount.toStringAsFixed(digitAfterDecimal)} ${appStore.currencySymbol}';
}

Future<void> commonLaunchUrl(String url, {bool forceWebView = false}) async {
  log(url);
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).then((value) {}).catchError((e) {
    toast('${language.invalidUrl}: $url');
  });
}

cashConfirmDialog() {
  showInDialog(
    getContext,
    contentPadding: EdgeInsets.all(16),
    builder: (p0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(language.balanceInsufficientCashPayment, style: primaryTextStyle(size: 16), textAlign: TextAlign.center),
          30.height,
          commonButton(language.ok, () {
            finish(getContext);
          }),
        ],
      );
    },
  );
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

String timeAgo(String date) {
  if (date.contains("week ago")) {
    return date.splitBefore("week ago").trim() + "w";
  }
  if (date.contains("year ago")) {
    return date.splitBefore("year ago").trim() + "y";
  }
  if (date.contains("month ago")) {
    return date.splitBefore("month ago").trim() + "m";
  }
  return date.toString();
}

String getMessageFromErrorCode(FirebaseException error) {
  switch (error.code) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "The email address is already in use by another account.";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
    default:
      return error.message.toString();
  }
}

List<String> userTypeList = [CLIENT, DELIVERY_MAN];

Future<void> openMap(double latitude, double longitude) async {
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunchUrl(Uri.parse(googleUrl))) {
    await launchUrl(Uri.parse(googleUrl));
  } else {
    throw 'Could not open the map.';
  }
}

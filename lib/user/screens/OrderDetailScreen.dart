import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../main/Chat/ChatScreen.dart';
import '../../main/components/CommonScaffoldComponent.dart';
import '../../main/components/OrderSummeryWidget.dart';
import '../../main/models/CountryListModel.dart';
import '../../main/models/ExtraChargeRequestModel.dart';
import '../../main/models/LoginResponse.dart';
import '../../main/models/OrderDetailModel.dart';
import '../../main/models/OrderListModel.dart';
import '../../main/network/RestApis.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import '../../main/utils/Images.dart';
import '../../main/utils/Widgets.dart';
import '../../user/components/CancelOrderDialog.dart';
import '../../user/screens/ReturnOrderScreen.dart';
import 'OrderHistoryScreen.dart';

class OrderDetailScreen extends StatefulWidget {
  static String tag = '/OrderDetailScreen';

  final int orderId;

  OrderDetailScreen({required this.orderId});

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  UserData? userData;

  OrderData? orderData;
  List<OrderHistory>? orderHistory;
  Payment? payment;
  List<ExtraChargeRequestModel> list = [];
  double? totalDistance;
  String? distance, duration;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    orderDetailApiCall();
  }

  orderDetailApiCall() async {
    appStore.setLoading(true);

    await getOrderDetails(widget.orderId).then((value) {
      orderData = value.data!;
      orderHistory = value.orderHistory!;
      payment = value.payment ?? Payment();

      if (orderData!.extraCharges.runtimeType == List<dynamic>) {
        (orderData!.extraCharges as List<dynamic>).forEach((element) {
          list.add(ExtraChargeRequestModel.fromJson(element));
        });
      }
      if (getStringAsync(USER_TYPE) == CLIENT) {
        userData = value.deliveryManDetail;
      } else {
        userData = value.clientDetail;
      }
      getDistanceApiCall();
      setState(() {});
    }).catchError((error) {
      toast(error.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  getDistanceApiCall() async {
    String? originLat = orderData!.pickupPoint!.latitude.validate();
    String? originLong = orderData!.pickupPoint!.longitude.validate();
    String? destinationLat = orderData!.deliveryPoint!.latitude.validate();
    String? destinationLong = orderData!.deliveryPoint!.longitude.validate();
    String origins = "${originLat},${originLong}";
    String destinations = "${destinationLat},${destinationLong}";
    await getDistanceBetweenLatLng(origins, destinations).then((value) {
      duration = value.rows[0].elements[0].duration.text;
      double distanceInKms = value.rows[0].elements[0].distance.text.toString().split(' ')[0].toDouble();
      if (appStore.distanceUnit == DISTANCE_UNIT_MILE) {
        totalDistance = (MILES_PER_KM * distanceInKms);
        distance = totalDistance.toString() + DISTANCE_UNIT_MILE;
      } else {
        totalDistance = distanceInKms;
        distance = totalDistance.toString() + DISTANCE_UNIT_KM;
      }
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    afterBuildCreated(() {
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: '${orderData != null ? orderData!.status!.replaceAll("_", " ").capitalizeFirstLetter() : ''}',
      body: Stack(
        children: [
          orderData != null
              ? Stack(
                  children: [
                    AnimatedScrollView(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: colorPrimary.withOpacity(0.3)), backgroundColor: Colors.transparent),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      orderData!.date != null
                                          ? Text(
                                                  '${DateFormat('dd MMM yyyy').format(DateTime.parse(orderData!.date!).toLocal())} ' +
                                                      ' ${language.at} ' +
                                                      ' ${DateFormat('hh:mm a').format(DateTime.parse(orderData!.date!).toLocal())}',
                                                  style: primaryTextStyle(size: 14))
                                              .expand()
                                          : SizedBox(),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(orderData!.parcelType.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          4.height,
                                          Row(
                                            children: [
                                              Text('# ${orderData!.id}', style: boldTextStyle(size: 14)).expand(),
                                              if (orderData!.status != ORDER_CANCELLED) Text(printAmount(orderData!.totalAmount ?? 0), style: boldTextStyle()),
                                            ],
                                          ),
                                          4.height,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    language.distance,
                                                    style: secondaryTextStyle(size: 14),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  4.width,
                                                  Text(
                                                    distance ?? "0",
                                                    style: boldTextStyle(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    language.duration,
                                                    style: secondaryTextStyle(size: 14),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  4.width,
                                                  Text(
                                                    duration ?? "0",
                                                    style: boldTextStyle(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ).visible(orderData!.pickupPoint != null && orderData!.deliveryPoint != null),
                                        ],
                                      ).expand(),
                                    ],
                                  ),
                                  8.height,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (orderData!.pickupDatetime != null)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(language.picked, style: secondaryTextStyle(size: 12)),
                                                    4.height,
                                                    Text('${language.at} ${printDate(orderData!.pickupDatetime!)}', style: secondaryTextStyle(size: 12)),
                                                  ],
                                                ),
                                              4.height,
                                              GestureDetector(
                                                onTap: () {
                                                  openMap(double.parse(orderData!.pickupPoint!.latitude.validate()), double.parse(orderData!.pickupPoint!.longitude.validate()));
                                                },
                                                child: Row(
                                                  children: [
                                                    ImageIcon(AssetImage(ic_from), size: 24, color: colorPrimary),
                                                    12.width,
                                                    Text('${orderData!.pickupPoint!.address}', style: secondaryTextStyle()).expand(),
                                                  ],
                                                ),
                                              ),
                                              if (orderData!.pickupDatetime == null && orderData!.pickupPoint!.endTime != null && orderData!.pickupPoint!.startTime != null)
                                                Text('${language.note} ${language.courierWillPickupAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(orderData!.pickupPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(orderData!.pickupPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(orderData!.pickupPoint!.endTime!).toLocal())}',
                                                        style: secondaryTextStyle(size: 12, color: Colors.red))
                                                    .paddingOnly(top: 4),
                                            ],
                                          ).expand(),
                                          12.width,
                                          if (orderData!.pickupPoint!.contactNumber != null)
                                            Icon(Ionicons.ios_call_outline, size: 20, color: colorPrimary).onTap(() {
                                              commonLaunchUrl('tel:${orderData!.pickupPoint!.contactNumber}');
                                            }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  16.height,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if (orderData!.deliveryDatetime != null)
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(language.delivered, style: secondaryTextStyle(size: 12)),
                                                        4.height,
                                                        Text('${language.at} ${printDate(orderData!.deliveryDatetime!)}', style: secondaryTextStyle(size: 12)),
                                                      ],
                                                    ),
                                                  4.height,
                                                  InkWell(
                                                    onTap: () {
                                                      openMap(double.parse(orderData!.deliveryPoint!.latitude.validate()), double.parse(orderData!.deliveryPoint!.longitude.validate()));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        ImageIcon(AssetImage(ic_to), size: 24, color: colorPrimary),
                                                        12.width,
                                                        Text('${orderData!.deliveryPoint!.address}', style: secondaryTextStyle(), textAlign: TextAlign.start).expand(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (orderData!.deliveryDatetime == null && orderData!.deliveryPoint!.endTime != null && orderData!.deliveryPoint!.startTime != null)
                                                Text('${language.note} ${language.courierWillDeliverAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(orderData!.deliveryPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(orderData!.deliveryPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(orderData!.deliveryPoint!.endTime!).toLocal())}',
                                                        style: secondaryTextStyle(color: Colors.red, size: 12))
                                                    .paddingOnly(top: 4)
                                            ],
                                          ).expand(),
                                          12.width,
                                          if (orderData!.deliveryPoint!.contactNumber != null)
                                            Icon(Ionicons.ios_call_outline, size: 20, color: colorPrimary).onTap(() {
                                              commonLaunchUrl('tel:${orderData!.deliveryPoint!.contactNumber}');
                                            }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (orderData!.status != ORDER_CANCELLED || (orderData!.status == ORDER_DEPARTED || orderData!.status == ORDER_ACCEPTED)) 16.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppButton(
                                        elevation: 0,
                                        height: 35,
                                        color: Colors.transparent,
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        shapeBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(defaultRadius),
                                          side: BorderSide(color: colorPrimary),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(language.viewHistory, style: primaryTextStyle(color: colorPrimary)),
                                            Icon(Icons.arrow_right, color: colorPrimary),
                                          ],
                                        ),
                                        onTap: () {
                                          OrderHistoryScreen(orderHistory: orderHistory.validate()).launch(context);
                                        },
                                      ).visible(orderData!.status == ORDER_DEPARTED || orderData!.status == ORDER_ACCEPTED),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            16.height,
                            Text(language.parcelDetails, style: boldTextStyle(size: 16)),
                            8.height,
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: colorPrimary.withOpacity(0.3)), backgroundColor: Colors.transparent),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: boxDecorationWithRoundedCorners(
                                            borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor, width: appStore.isDarkMode ? 0.2 : 1), backgroundColor: Colors.transparent),
                                        padding: EdgeInsets.all(8),
                                        child: Image.asset(parcelTypeIcon(orderData!.parcelType.validate()), height: 24, width: 24, color: Colors.grey),
                                      ),
                                      8.width,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(orderData!.parcelType.validate(), style: boldTextStyle()),
                                          4.height,
                                          Text('${orderData!.totalWeight} ${CountryModel.fromJson(getJSONAsync(COUNTRY_DATA)).weightType}', style: secondaryTextStyle()),
                                        ],
                                      ).expand(),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(language.numberOfParcels, style: secondaryTextStyle()),
                                      Text('${orderData!.totalParcel ?? 1}', style: boldTextStyle(size: 14)),
                                    ],
                                  ).visible(orderData!.totalParcel != null),
                                ],
                              ),
                            ),
                            16.height,
                            Text(language.paymentDetails, style: boldTextStyle(size: 16)),
                            12.height,
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: colorPrimary.withOpacity(0.3)), backgroundColor: Colors.transparent),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(language.paymentType, style: secondaryTextStyle()),
                                      Text('${paymentType(orderData!.paymentType.validate(value: PAYMENT_TYPE_CASH))}', style: boldTextStyle(size: 14)),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(language.paymentStatus, style: secondaryTextStyle()),
                                      Text('${paymentStatus(orderData!.paymentStatus.validate(value: PAYMENT_PENDING))}', style: boldTextStyle(size: 14)),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(language.paymentCollectFrom, style: secondaryTextStyle()),
                                      Text('${paymentCollectForm(orderData!.paymentCollectFrom!)}', style: boldTextStyle(size: 14)),
                                    ],
                                  ).visible(orderData!.paymentType.validate(value: PAYMENT_TYPE_CASH) == PAYMENT_TYPE_CASH),
                                ],
                              ),
                            ),
                            if (orderData!.vehicleData != null) 16.height,
                            if (orderData!.vehicleData != null) Text(language.vehicle, style: boldTextStyle()),
                            if (orderData!.vehicleData != null) 12.height,
                            if (orderData!.vehicleData != null)
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                    borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: colorPrimary.withOpacity(0.3)), backgroundColor: Colors.transparent),
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (orderData!.vehicleImage != null)
                                      ClipRRect(borderRadius: BorderRadius.circular(10), child: commonCachedNetworkImage(orderData!.vehicleImage, fit: BoxFit.fill, height: 100, width: 150)),
                                    8.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [Text(language.vehicleName, style: secondaryTextStyle()), Text('${orderData!.vehicleData!.title.validate()}', style: primaryTextStyle())],
                                    ),
                                  ],
                                ),
                              ),
                            if (userData != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  16.height,
                                  Text('${getStringAsync(USER_TYPE) == CLIENT ? language.aboutDeliveryMan : language.aboutUser}', style: boldTextStyle(size: 16)),
                                  12.height,
                                  Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                        borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: colorPrimary.withOpacity(0.3)), backgroundColor: Colors.transparent),
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.network(userData!.profileImage.validate(), height: 60, width: 60, fit: BoxFit.cover, alignment: Alignment.center)
                                                .cornerRadiusWithClipRRect(60)
                                                .visible(!userData!.profileImage.isEmptyOrNull),

                                            commonCachedNetworkImage(ic_profile, height: 60, width: 60, fit: BoxFit.cover, alignment: Alignment.center)
                                                .cornerRadiusWithClipRRect(60)
                                                .visible(userData!.profileImage.isEmptyOrNull),
                                            8.width,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('${userData!.name.validate()}', style: boldTextStyle()),
                                                        4.width,
                                                        if (getStringAsync(USER_TYPE) == CLIENT && userData!.isVerifiedDeliveryMan == 1) Icon(Octicons.verified, color: Colors.green, size: 18),
                                                      ],
                                                    ),
                                                    InkWell(
                                                            onTap: () {
                                                              ChatScreen(userData: userData).launch(context);
                                                            },
                                                            child: Icon(Ionicons.md_chatbox_outline, size: 22, color: colorPrimary))
                                                        .visible(orderData!.status != ORDER_DELIVERED && orderData!.status != ORDER_CANCELLED),
                                                  ],
                                                ),
                                                4.height,
                                                userData!.contactNumber != null
                                                    ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('${userData!.contactNumber}', style: secondaryTextStyle()).paddingOnly(top: 4).onTap(() {
                                                            commonLaunchUrl('tel:${userData!.contactNumber}');
                                                          }),
                                                          InkWell(
                                                              onTap: () {
                                                                commonLaunchUrl('tel:${userData!.contactNumber}');
                                                                //   ChatScreen(userData: userData).launch(context);
                                                              },
                                                              child: Icon(Ionicons.call_outline, size: 22, color: colorPrimary))
                                                        ],
                                                      )
                                                    : SizedBox()
                                              ],
                                            ).expand(),

                                            //  .visible(orderData!.status != ORDER_DELIVERED && orderData!.status != ORDER_CANCELLED && userData!.userType!=ADMIN && userData!.userType!=DEMO_ADMIN)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            if (orderData!.reason.validate().isNotEmpty && orderData!.status != ORDER_CANCELLED)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  24.height,
                                  Text(language.returnReason, style: boldTextStyle()),
                                  12.height,
                                  Container(
                                    width: context.width(),
                                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.all(12),
                                    child: Text('${orderData!.reason.validate(value: "-")}', style: primaryTextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            if (orderData!.status == ORDER_CANCELLED)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  24.height,
                                  Text(language.cancelledReason, style: boldTextStyle()),
                                  12.height,
                                  Container(
                                    width: context.width(),
                                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.all(12),
                                    child: Text('${orderData!.reason.validate(value: "-")}', style: primaryTextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            16.height,
                            (orderData!.extraCharges!.runtimeType == List<dynamic>)
                                ? OrderSummeryWidget(
                                    extraChargesList: list,
                                    totalDistance: orderData!.totalDistance,
                                    totalWeight: orderData!.totalWeight.validate(),
                                    distanceCharge: orderData!.distanceCharge.validate(),
                                    weightCharge: orderData!.weightCharge.validate(),
                                    totalAmount: orderData!.totalAmount,
                                    payment: payment,
                                    status: orderData!.status,
                                    isDetail: true,
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(language.deliveryCharge, style: primaryTextStyle()),
                                          16.width,
                                          Text('${printAmount(orderData!.fixedCharges.validate())}', style: primaryTextStyle()),
                                        ],
                                      ),
                                      if (orderData!.distanceCharge.validate() != 0)
                                        Column(
                                          children: [
                                            8.height,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.distanceCharge, style: primaryTextStyle()),
                                                16.width,
                                                Text('${printAmount(orderData!.distanceCharge.validate())}', style: primaryTextStyle()),
                                              ],
                                            )
                                          ],
                                        ),
                                      if (orderData!.weightCharge.validate() != 0)
                                        Column(
                                          children: [
                                            8.height,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(language.weightCharge, style: primaryTextStyle()),
                                                16.width,
                                                Text('${printAmount(orderData!.weightCharge.validate())}', style: primaryTextStyle()),
                                              ],
                                            ),
                                          ],
                                        ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Column(
                                          children: [
                                            8.height,
                                            Text('${printAmount(orderData!.fixedCharges.validate() + orderData!.distanceCharge.validate() + orderData!.weightCharge.validate())}',
                                                style: primaryTextStyle()),
                                          ],
                                        ),
                                      ).visible((orderData!.distanceCharge.validate() != 0 || orderData!.weightCharge.validate() != 0) && orderData!.extraCharges.keys.length != 0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          16.height,
                                          Text(language.extraCharges, style: boldTextStyle()),
                                          8.height,
                                          Column(
                                              children: List.generate(orderData!.extraCharges.keys.length, (index) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(orderData!.extraCharges.keys.elementAt(index).replaceAll("_", " "), style: primaryTextStyle()),
                                                  16.width,
                                                  Text('${printAmount(orderData!.extraCharges.values.elementAt(index))}', style: primaryTextStyle()),
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        ],
                                      ).visible(orderData!.extraCharges.keys.length != 0),
                                      16.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(language.total, style: boldTextStyle(size: 20)),
                                          (orderData!.status == ORDER_CANCELLED && payment != null && payment!.deliveryManFee == 0)
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('${printAmount(orderData!.totalAmount.validate())}', style: secondaryTextStyle(size: 16, decoration: TextDecoration.lineThrough)),
                                                    8.width,
                                                    Text('${printAmount(payment!.cancelCharges.validate())}', style: boldTextStyle(size: 20)),
                                                  ],
                                                )
                                              : Text('${printAmount(orderData!.totalAmount.validate())}', style: boldTextStyle(size: 20)),
                                        ],
                                      ),
                                    ],
                                  ),
                            16.height,
                            if (orderData!.status == ORDER_CANCELLED && payment != null)
                              Container(
                                width: context.width(),
                                decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.all(12),
                                child:
                                    Text('${language.note} ${payment!.deliveryManFee == 0 ? language.cancelBeforePickMsg : language.cancelAfterPickMsg}', style: secondaryTextStyle(color: Colors.red)),
                              ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  commonButton(language.cancelOrder, () {
                                    showInDialog(
                                      context,
                                      backgroundColor: colorPrimaryLight,
                                      contentPadding: EdgeInsets.all(16),
                                      builder: (p0) {
                                        return CancelOrderDialog(
                                            orderId: orderData!.id.validate(),
                                            onUpdate: () {
                                              orderDetailApiCall();
                                              LiveStream().emit('UpdateOrderData');
                                            });
                                      },
                                    );
                                  }, width: context.width()),
                                  8.height,
                                  Container(
                                    width: context.width(),
                                    decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.all(12),
                                    child: Text(language.cancelNote, style: secondaryTextStyle()),
                                  ),
                                ],
                              ),
                            ).visible(getStringAsync(USER_TYPE) == CLIENT && orderData!.status != ORDER_DELIVERED && orderData!.status != ORDER_CANCELLED),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: commonButton(language.returnOrder, () {
                                ReturnOrderScreen(orderData!).launch(context);
                              }, width: context.width()),
                            ).visible(orderData!.status == ORDER_DELIVERED && !orderData!.returnOrderId! && getStringAsync(USER_TYPE) == CLIENT),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          Observer(builder: (context) => loaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}

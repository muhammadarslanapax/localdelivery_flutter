import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:mighty_delivery/main/models/OrderListModel.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import '../../main/utils/Images.dart';
import '../screens/OrderDetailScreen.dart';
import '../screens/OrderTrackingScreen.dart';
import 'GenerateInvoice.dart';

class OrderCardComponent extends StatefulWidget {
  final OrderData item;

  OrderCardComponent({required this.item});

  @override
  _OrderCardComponentState createState() => _OrderCardComponentState();
}

class _OrderCardComponentState extends State<OrderCardComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OrderDetailScreen(orderId: widget.item.id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: 400.milliseconds);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: colorPrimary.withOpacity(0.3)), backgroundColor: Colors.transparent),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.item.date != null
                    ? Text(DateFormat('dd MMM yyyy').format(DateTime.parse(widget.item.date!).toLocal()) + " at " + DateFormat('hh:mm a').format(DateTime.parse(widget.item.date!).toLocal()),
                            style: primaryTextStyle(size: 14))
                        .expand()
                    : SizedBox(),
                Container(
                  decoration: BoxDecoration(color: statusColor(widget.item.status.validate()).withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(orderStatus(widget.item.status!), style: primaryTextStyle(size: 14, color: statusColor(widget.item.status.validate()))),
                ),
              ],
            ),
            8.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor, width: appStore.isDarkMode ? 0.2 : 1), backgroundColor: context.cardColor),
                  padding: EdgeInsets.all(8),
                  child: Image.asset(parcelTypeIcon(widget.item.parcelType.validate()), height: 24, width: 24, color: colorPrimary),
                ),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item.parcelType.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                    4.height,
                    Row(
                      children: [
                        Text('# ${widget.item.id}', style: boldTextStyle(size: 14)).expand(),
                        if (widget.item.status != ORDER_CANCELLED) Text(printAmount(widget.item.totalAmount ?? 0), style: boldTextStyle()),
                      ],
                    ),
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
                        if (widget.item.pickupDatetime != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.picked, style: secondaryTextStyle(size: 12)),
                              4.height,
                              Text('${language.at} ${printDate(widget.item.pickupDatetime!)}', style: secondaryTextStyle(size: 12)),
                            ],
                          ),
                        4.height,
                        GestureDetector(
                          onTap: () {
                            openMap(double.parse(widget.item.pickupPoint!.latitude.validate()), double.parse(widget.item.pickupPoint!.longitude.validate()));
                          },
                          child: Row(
                            children: [
                              ImageIcon(AssetImage(ic_from), size: 24, color: colorPrimary),
                              12.width,
                              Text('${widget.item.pickupPoint!.address}', style: primaryTextStyle()).expand(),
                            ],
                          ),
                        ),
                        if (widget.item.pickupDatetime == null && widget.item.pickupPoint!.endTime != null && widget.item.pickupPoint!.startTime != null)
                          Text('${language.note} ${language.courierWillPickupAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.item.pickupPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(widget.item.pickupPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(widget.item.pickupPoint!.endTime!).toLocal())}',
                                  style: secondaryTextStyle(size: 12, color: Colors.red))
                              .paddingOnly(top: 4)
                              .paddingOnly(top: 4),
                      ],
                    ).expand(),
                    12.width,
                    if (widget.item.pickupPoint!.contactNumber != null)
                      Icon(Ionicons.ios_call_outline, size: 20, color: colorPrimary).onTap(() {
                        commonLaunchUrl('tel:${widget.item.pickupPoint!.contactNumber}');
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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.item.deliveryDatetime != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(language.delivered, style: secondaryTextStyle(size: 12)),
                                  4.height,
                                  Text('${language.at} ${printDate(widget.item.deliveryDatetime!)}', style: secondaryTextStyle(size: 12)),
                                ],
                              ),
                            4.height,
                            GestureDetector(
                              onTap: () {
                                openMap(double.parse(widget.item.deliveryPoint!.latitude.validate()), double.parse(widget.item.deliveryPoint!.longitude.validate()));
                              },
                              child: Row(
                                children: [
                                  ImageIcon(AssetImage(ic_to), size: 24, color: colorPrimary),
                                  12.width,
                                  Text('${widget.item.deliveryPoint!.address}', style: primaryTextStyle(), textAlign: TextAlign.start).expand(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (widget.item.deliveryDatetime == null && widget.item.deliveryPoint!.endTime != null && widget.item.deliveryPoint!.startTime != null)
                          Text('${language.note} ${language.courierWillDeliverAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.item.deliveryPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(widget.item.deliveryPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(widget.item.deliveryPoint!.endTime!).toLocal())}',
                                  style: secondaryTextStyle(color: Colors.red, size: 12))
                              .paddingOnly(top: 4)
                      ],
                    ).expand(),
                    12.width,
                    if (widget.item.deliveryPoint!.contactNumber != null)
                      Icon(Ionicons.ios_call_outline, size: 20, color: colorPrimary).onTap(() {
                        commonLaunchUrl('tel:${widget.item.deliveryPoint!.contactNumber}');
                      }),
                  ],
                ),
              ],
            ),
            if (widget.item.status != ORDER_CANCELLED || (widget.item.status == ORDER_DEPARTED || widget.item.status == ORDER_ACCEPTED)) 16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.item.status != ORDER_CANCELLED)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: colorPrimary),
                    child: Row(
                      children: [
                        Text(language.invoice, style: secondaryTextStyle(color: Colors.white)),
                        4.width,
                        Icon(Ionicons.md_download_outline, color: Colors.white, size: 18).paddingBottom(4),
                      ],
                    ).onTap(() {
                      generateInvoiceCall(widget.item);
                    }),
                  ),
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
                      Text(language.trackOrder, style: primaryTextStyle(color: colorPrimary)),
                      Icon(Icons.arrow_right, color: colorPrimary),
                    ],
                  ),
                  onTap: () {
                    OrderTrackingScreen(orderData: widget.item).launch(context);
                  },
                ).visible((widget.item.status == ORDER_DEPARTED || widget.item.status == ORDER_ACCEPTED) && appStore.userType != DELIVERY_MAN),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

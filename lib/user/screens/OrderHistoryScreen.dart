import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../main.dart';
import '../../main/models/OrderDetailModel.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';
import '../../main/utils/Widgets.dart';

class OrderHistoryScreen extends StatefulWidget {
  static String tag = '/OrderHistoryScreen';

  final List<OrderHistory> orderHistory;

  OrderHistoryScreen({required this.orderHistory});

  @override
  OrderHistoryScreenState createState() => OrderHistoryScreenState();
}

class OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(language.orderHistory),
      body: Observer(builder: (context) {
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: widget.orderHistory.length,
          itemBuilder: (context, index) {
            OrderHistory mData = widget.orderHistory[index];
            return TimelineTile(
              alignment: TimelineAlign.start,
              isFirst: index == 0 ? true : false,
              axis: TimelineAxis.vertical,
              isLast: index == (widget.orderHistory.length - 1) ? true : false,
              indicatorStyle: IndicatorStyle(width: 15, color: colorPrimary),
              afterLineStyle: LineStyle(color: colorPrimary, thickness: 3),
              beforeLineStyle: LineStyle(color: colorPrimary, thickness: 3),
              endChild: Row(
                children: [
                  ImageIcon(AssetImage(statusTypeIcon(type: mData.historyType)), color: colorPrimary.withOpacity(0.8), size: 20),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderStatus('${mData.historyType!}'), style: boldTextStyle()),
                      2.height,
                      Text(messageData(mData)),
                      2.height,
                      Text('${printDate('${mData.createdAt}')}', style: secondaryTextStyle(size: 12)),
                    ],
                  ).expand(),
                ],
              ).paddingAll(12),
            );
          },
        );
      }),
    );
  }

  messageData(OrderHistory orderData) {
    if (orderData.historyType == ORDER_ASSIGNED) {
      return '${language.yourOrder} #${orderData.orderId} ${language.hasBeenAssignedTo} ${orderData.historyData!.deliveryManName}.';
    } else if (orderData.historyType == ORDER_TRANSFER) {
      return '${language.yourOrder} #${orderData.orderId} ${language.hasBeenTransferedTo} ${orderData.historyData!.deliveryManName}.';
    } else if (orderData.historyType == ORDER_CREATED) {
      return language.newOrderHasBeenCreated;
    } else if (orderData.historyType == ORDER_PICKED_UP) {
      return language.deliveryPersonArrivedMsg;
    } else if (orderData.historyType == ORDER_CREATED) {
      return language.deliveryPersonPickedUpCourierMsg;
    } else if (orderData.historyType == ORDER_DEPARTED) {
      return '${language.yourOrder} #${orderData.orderId}  ${language.hasBeenOutForDelivery}';
    } else if (orderData.historyType == ORDER_PAYMENT) {
      return '${language.yourOrder} #${orderData.orderId} ${language.paymentStatusPaisMsg}';
    } else if (orderData.historyType == ORDER_DELIVERED) {
      return '${language.yourOrder} #${orderData.orderId}  ${language.deliveredMsg}';
    } else {
      return '${orderData.historyMessage}';
    }
  }
}

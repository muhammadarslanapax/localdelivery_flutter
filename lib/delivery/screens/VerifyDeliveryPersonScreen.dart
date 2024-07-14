import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import '../../main/components/BodyCornerWidget.dart';
import '../../main/components/CommonScaffoldComponent.dart';
import '../../main/models/DeliveryDocumentListModel.dart';
import '../../main/models/DocumentListModel.dart';
import '../../main/network/RestApis.dart';
import '../../main/utils/Colors.dart';
import '../../main/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../main/network/NetworkUtils.dart';
import '../../main/utils/Constants.dart';

class VerifyDeliveryPersonScreen extends StatefulWidget {
  static String tag = '/VerifyDeliveryPersonScreen';

  @override
  VerifyDeliveryPersonScreenState createState() => VerifyDeliveryPersonScreenState();
}

class VerifyDeliveryPersonScreenState extends State<VerifyDeliveryPersonScreen> {
  List<DocumentData> documents = [];
  List<DeliveryDocumentData> deliveryPersonDocuments = [];
  DocumentListModel? documentListModel;
  FilePickerResult? filePickerResult;
  List<File>? imageFiles;
  List<String> eAttachments = [];
  int? updateDocId;
  List<int>? uploadedDocList = [];
  DocumentData? selectedDoc;
  int docId = 0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    await getDocListApiCall();
    await getDeliveryDocListApiCall();
  }

  /// get Document list
  getDocListApiCall() {
    appStore.setLoading(true);
    getDocumentList().then((res) {
      documents.addAll(res.data!);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  ///Get Delivery Documents List
  getDeliveryDocListApiCall() {
    getDeliveryPersonDocumentList().then((res) {
      appStore.setLoading(false);
      deliveryPersonDocuments.addAll(res.data!);
      deliveryPersonDocuments.forEach((element) {
        uploadedDocList!.add(element.documentId!);
        updateDocId = element.id;
        log(uploadedDocList);
      });
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  /// SelectImage
  getMultipleFile(int? docId, {int? updateId}) async {
    filePickerResult = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf']);

    if (filePickerResult != null) {
      showConfirmDialogCustom(
        context,
        title: language.uploadFileConfirmationMsg,
        onAccept: (BuildContext context) {
          setState(() {
            imageFiles = filePickerResult!.paths.map((path) => File(path!)).toList();
            eAttachments = [];
          });
          addDocument(docId, updateId: updateId);
        },
        positiveText: language.yes,
        negativeText: language.no,
        primaryColor: colorPrimary,
      );
    } else {}
  }

  /// Add Documents
  addDocument(int? docId, {int? updateId}) async {
    MultipartRequest multiPartRequest = await getMultiPartRequest('delivery-man-document-save');
    multiPartRequest.fields["id"] = updateId != null ? updateId.toString() : '';
    multiPartRequest.fields["delivery_man_id"] = getIntAsync(USER_ID).toString();
    multiPartRequest.fields["document_id"] = docId.toString();
    multiPartRequest.fields["is_verified"] = '0';
    if (imageFiles != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath("delivery_man_document", imageFiles!.first.path));
    }
    log(multiPartRequest);
    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);

        deliveryPersonDocuments.clear();
        getDeliveryDocListApiCall();
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  /// Delete Documents
  deleteDoc(int? id) {
    appStore.setLoading(true);
    deleteDeliveryDoc(id!).then((value) {
      toast(value.message, print: true);
      uploadedDocList!.clear();
      deliveryPersonDocuments.clear();
      getDeliveryDocListApiCall();
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  String getStatus(int i) {
    String status = language.pending;
    if (i == 0) {
      status = language.pending;
    } else if (i == 1) {
      status = language.approved;
    } else if (i == 2) {
      status = language.rejected;
    }
    return status;
  }

  Color getColor(int i) {
    Color color = colorPrimary;
    if (i == 0) {
      color = colorPrimary;
    } else if (i == 1) {
      color = Colors.green;
    } else if (i == 2) {
      color = Colors.red;
    }
    return color;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: language.verifyDocument,
      body: Observer(
        builder: (_) => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (documents.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: Colors.transparent),
                          child: DropdownButtonFormField<DocumentData>(
                            decoration: commonInputDecoration(),
                            hint: Text(language.selectDocument, style: primaryTextStyle()),
                            value: selectedDoc,
                            dropdownColor: context.cardColor,
                            items: documents.map((DocumentData e) {
                              return DropdownMenuItem<DocumentData>(
                                value: e,
                                child: Text(e.name! + '${e.isRequired == 1 ? '*' : ''}', style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (DocumentData? value) async {
                              selectedDoc = value;
                              docId = value!.id!;
                              setState(() {});
                            },
                          ),
                        ).expand(),
                      if (docId != 0)
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 16),
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: colorPrimary, borderRadius: BorderRadius.circular(defaultRadius)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 24),
                              8.width,
                              Text(language.addDocument, style: secondaryTextStyle(color: Colors.white)),
                            ],
                          ),
                        ).onTap(() {
                          getMultipleFile(docId);
                        }).visible(!uploadedDocList!.contains(docId)),
                    ],
                  ),
                  30.height,
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: deliveryPersonDocuments.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(deliveryPersonDocuments[index].documentName!, style: boldTextStyle()).expand(),
                              Text(
                                getStatus(deliveryPersonDocuments[index].isVerified.validate()),
                                style: primaryTextStyle(
                                  color: getColor(deliveryPersonDocuments[index].isVerified.validate()),
                                ),
                              ),
                              8.width,
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: colorPrimary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: colorPrimary),
                                ),
                                child: Icon(Icons.edit, color: colorPrimary, size: 14),
                              ).onTap(() {
                                getMultipleFile(deliveryPersonDocuments[index].documentId, updateId: deliveryPersonDocuments[index].id.validate());
                              }).visible(deliveryPersonDocuments[index].isVerified != 1),
                              8.width.visible(deliveryPersonDocuments[index].isVerified != 1),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Icon(Icons.delete, color: Colors.red, size: 14),
                              ).onTap(() {
                                deleteDoc(deliveryPersonDocuments[index].id);
                              }).visible(deliveryPersonDocuments[index].isVerified != 1),
                              Icon(Icons.verified_user, color: Colors.green).visible(deliveryPersonDocuments[index].isVerified == 1),
                            ],
                          ),
                          12.height,
                          deliveryPersonDocuments[index].deliveryManDocument!.contains('.pdf')
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.grey.withOpacity(0.2)),
                                  child: Text(deliveryPersonDocuments[index].deliveryManDocument!.split('/').last, style: primaryTextStyle()),
                                ).onTap(() {
                                  commonLaunchUrl(deliveryPersonDocuments[index].deliveryManDocument.validate());
                                })
                              : commonCachedNetworkImage(deliveryPersonDocuments[index].deliveryManDocument!, height: 200, width: context.width(), fit: BoxFit.cover)
                                  .cornerRadiusWithClipRRect(8)
                                  .onTap(() {
                                  commonLaunchUrl(deliveryPersonDocuments[index].deliveryManDocument!.validate());
                                }),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(height: 30,color: context.dividerColor);
                    },
                  ),
                ],
              ),
            ),
            emptyWidget().visible(!appStore.isLoading && documents.isEmpty && deliveryPersonDocuments.isEmpty),
            loaderWidget().center().visible(appStore.isLoading),
          ],
        ),
      ),
    );
  }
}

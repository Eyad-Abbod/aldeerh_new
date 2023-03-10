import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:byahmed_eyone/admin/dashboard.dart';
import 'package:byahmed_eyone/admin/secreens/change_image.dart';
import 'package:byahmed_eyone/admin/secreens/search_change_user.dart';
import 'package:byahmed_eyone/screens/shared_ui/photo_news_img.dart';
import 'package:byahmed_eyone/shared_ui/custom_with_edit.dart';
import 'package:byahmed_eyone/utilities/crud.dart';
import 'package:byahmed_eyone/utilities/link_app.dart';
import 'package:byahmed_eyone/utilities/app_theme.dart';
import 'package:byahmed_eyone/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class EditNewsAdmin extends StatefulWidget {
  const EditNewsAdmin({
    Key? key,
    required this.screenType,
    required this.title,
    required this.nsid,
    required this.content,
    required this.type,
    required this.name,
    required this.typeOf,
    required this.nsImg,
    required this.usty,
    required this.dateEnd,
    required this.usph,
    required this.direct,
    required this.newsState,
  }) : super(key: key);
  final int screenType;
  final String title;
  final String nsid;
  final String name;
  final int type;
  final int typeOf;
  final String usty;
  final DateTime dateEnd;

  final String content;
  final String nsImg;
  final String usph;
  final bool direct;
  final int newsState;
  @override
  State<EditNewsAdmin> createState() => _EditNewsAdminState();
}

class _EditNewsAdminState extends State<EditNewsAdmin> {
  // late StreamSubscription streamSubscription;
  DateTime dateTime = DateTime.now();
  bool changeDate = false;

  DateTime dateTimeToUplodeString = DateTime.now();
  DateTime dateTimeToUplode = DateTime.now();
  late int type;
  late int typeOf;
  late int newsState;
  String backValueName = '';
  String backValueImage = '';

  int newsOrAds = 0;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  final controller = MultiImagePickerController(
    maxImages: 6,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );
  final List images = [];

  void _firstLoad() async {
    try {
      var a = widget.nsid;

      final res = await http.get(Uri.parse("$linkImagesNews?nsid=$a"));
      if (mounted) {
        isImagesLoading = false;
        setState(() {
          images.addAll(json.decode(res.body));
        });
      }
      // print(images);
    } catch (e) {
      if (mounted) {
        await AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.ERROR,
          // dialogColor: AppTheme.appTheme.primaryColor,
          title: '??????',
          // desc: '???????? ???? ???????? ????????????????',
          desc: '???? ?????? ???????????? ???? ???????? ?????????? ???????????????? ???????? ???? ???????? ????????????????',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: '???????? ???? ???????? ????????????????',
          // btnCancelOnPress: () {},
          // btnCancelColor: AppTheme.appTheme.primaryColor,
          // btnCancelText: '???????????? ??????????????'
        ).show();
        _firstLoad();
        isImagesLoading = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    title.text = widget.title;
    content.text = widget.content;
    type = widget.type;
    typeOf = widget.typeOf;
    newsState = widget.newsState;
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

  File? file;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  String imageToDelete = '';
  final List<XFile> iamgesList = [];
  List<File> fileList = [];
  bool isLoading = false;
  bool isImagesLoading = true;
  final Curd _curd = Curd();
  Future pickImage(ImageSource source) async {
    try {
      final iamge = await ImagePicker().pickImage(source: source);
      if (iamge == null) return;

      final imageTemporary = File(iamge.path);
      if (mounted) {
        setState(() => file = imageTemporary);
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  List<File> files = [];
  editNewsAdmin() async {
    final images = controller.images; // return Iterable<ImageFile>
    for (final image in images) {
      if (image.hasPath) files.add(File(image.path!));
    }
    if (file == null &&
        newsState == widget.newsState &&
        title.text == widget.title &&
        content.text == widget.content &&
        type == widget.type &&
        typeOf == widget.typeOf &&
        changeDate == false &&
        files.isEmpty) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.ERROR,
          // dialogColor: AppTheme.appTheme.primaryColor,
          title: '??????????',
          desc: '???? ?????? ???????????? ???? ????????????',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: '????????',
        ).show();
      }
    } else {
      if (formstate.currentState!.validate()) {
        for (int i = 0; i < iamgesList.length; i++) {
          files.add(File(iamgesList[i].path));
        }

        var moreImages = 'no';
        if (files.isNotEmpty) {
          moreImages = 'yes';
        }
        isLoading = true;
        if (changeDate == true) {
          dateTimeToUplode = dateTimeToUplodeString;
        } else {
          dateTimeToUplode = widget.dateEnd;
        }
        if (mounted) {
          setState(() {});
        }
        for (var i = 0; i < iamgesList.length; i++) {
          fileList.add(File(iamgesList[i].path));
        }

        dynamic response;
        if (file == null) {
          response = await _curd.postRequestWithFilesWithOutFile(
              linkEditNewsAdmin,
              {
                'ns_title': title.text,
                'ns_txt': content.text,
                'nsid': widget.nsid,
                'moreImg': moreImages,
                'changeImage': 'no',
                'ns_ty': type.toString(),
                'ns_pos': typeOf.toString(), //
                'oldImageName': widget.nsImg,
                'news_state': newsState.toString(),
                'dateEnd':
                    '${dateTimeToUplode.year}-${dateTimeToUplode.month}-${dateTimeToUplode.day}', //
              },
              files);
        } else {
          response = await _curd.postRequestWithFiles(
              linkEditNews,
              {
                'ns_title': title.text,
                'ns_txt': content.text,
                'nsid': widget.nsid,
                'moreImg': moreImages,
                'changeImage': 'yes',
                'oldImageName': widget.nsImg,
                'news_state': newsState.toString(),
                'dateEnd':
                    '${dateTimeToUplode.year}-${dateTimeToUplode.month}-${dateTimeToUplode.day}', //
              },
              file,
              files);
        }

        isLoading = false;

        if (mounted) {
          setState(() {});
          if (response['status'] == 'success') {
            if (widget.newsState != newsState &&
                newsState == 1 &&
                (type == 1 || type == 2 || type == 3)) {
              _curd.postRequestNotifications(
                widget.title,
                widget.name,
                widget.nsid,
              );
            }
            if (mounted) {
              await AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.SUCCES,
                title: '????????',
                desc: '???? ?????????????? ??????????',
                btnOkOnPress: () {},
                btnOkColor: Colors.blue,
                btnOkText: '????????',
              ).show();
            }
          }

          Get.offAll(() => const DashboardScreen());
        } else {
          if (mounted) {
            await AwesomeDialog(
              context: context,
              animType: AnimType.TOPSLIDE,
              dialogType: DialogType.ERROR,
              title: '??????',
              desc: '???????? ???? ???????? ????????????????',
              btnOkOnPress: () {},
              btnOkColor: Colors.blue,
              btnOkText: 'Ok',
            ).show();
          }
        }
      }
    }
  }

  // void selectImages() async {
  //   try {
  //     final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
  //     if (selectedImages!.isNotEmpty) {
  //       iamgesList.addAll(selectedImages);
  //     }

  //     print('Images list lingth :${iamgesList.length}');
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  //   if (mounted) {
  // setState(() {});
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            itemBuilder: ((context) => [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () async {
                        String val = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return ChangeUser(
                              nsid: widget.nsid,
                            );
                          }),
                        );
                        if (mounted) {
                          setState(() {
                            backValueName = val;
                          });
                        }

                        // print(val);
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.image,
                            color: Colors.black,
                          ),
                          Text(' ???????? ????????????????'),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () async {
                        String val = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return ChangeNewsImage(
                                nsid: widget.nsid, nsImg: widget.nsImg);
                          }),
                        );
                        if (mounted) {
                          setState(() {
                            backValueImage = val;
                          });
                        }
                        // print(val);
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          Text(' ???????? ????????????'),
                        ],
                      ),
                    ),
                  ),
                ]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.appTheme.primaryColor,
        label: const Text('?????????? ??????????'),
        onPressed: () => editNewsAdmin(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formstate,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      newsPict(),
                      const SizedBox(height: 15),
                      newsTitleAndContent(),
                      const SizedBox(height: 10),
                      buildNewsType(context),
                      isImagesLoading
                          ? const Center(
                              child: CupertinoActivityIndicator(
                                  color: Colors.black))
                          : images.isNotEmpty
                              ? newsImagesNow()
                              : const SizedBox(height: 0),
                      const SizedBox(height: 15),
                      addNewImages(),
                    ]),
              ),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.white38,
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(child: CupertinoActivityIndicator()))
              : const SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget newsPict() {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          file != null
              ? InkWell(
                  onTap: () {
                    Get.to(() => const PhotoNewsImg(), arguments: [
                      widget.nsImg,
                      0,
                      widget.title,
                    ]);
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.file(
                      file!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    Get.to(() => const PhotoNewsImg(), arguments: [
                      widget.nsImg,
                      0,
                      widget.title,
                    ]);
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: backValueImage != ''
                        ? FadeInImage.memoryNetwork(
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeOutDuration: const Duration(milliseconds: 500),
                            placeholder: kTransparentImage,

                            image: linkImageRoot + backValueImage,
                            imageErrorBuilder: (c, o, s) => Image.asset(
                              "assets/AlUyun2.png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            placeholderErrorBuilder: (c, o, s) => Image.asset(
                              "assets/AlUyun2.png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            // repeat: ImageRepeat.repeat,
                          )
                        : FadeInImage.memoryNetwork(
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeOutDuration: const Duration(milliseconds: 500),
                            placeholder: kTransparentImage,

                            image: linkImageRoot + widget.nsImg,
                            imageErrorBuilder: (c, o, s) => Image.asset(
                              "assets/AlUyun2.png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            placeholderErrorBuilder: (c, o, s) => Image.asset(
                              "assets/AlUyun2.png",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            // repeat: ImageRepeat.repeat,
                          ),
                  ),
                ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150.0,
                // height: 100.0,
                child: ElevatedButton(
                  onPressed: () => pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.appTheme.primaryColor, // Background color
                  ),
                  child: const Text(
                    '?????????? ??????????',
                  ),
                ),
              ),
              SizedBox(
                  width: 150.0,
                  // height: 100.0,
                  child: ElevatedButton(
                    onPressed: () => pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.appTheme.primaryColor, // Background color
                    ),
                    child: const Text(
                      '????????????????',
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget newsTitleAndContent() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.usty == '1'
                ? Icon(
                    Icons.person,
                    size: 22,
                    color: AppTheme.appTheme.primaryColor,
                  )
                : const Icon(
                    Icons.verified,
                    size: 22,
                    color: Colors.blue,
                  ),
            Flexible(
                child: backValueName != ''
                    ? Text(
                        ' $backValueName',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 22),
                      )
                    : InkWell(
                        onTap: () => openWhatsApp(widget.usph),
                        child: Text(
                          ' ${widget.name}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ))
          ],
        ),
        const SizedBox(height: 15),

        // Text(widget.name),
        CustTextFormWithEdit(
          hint: "?????????? ??????????",
          ourInput: TextInputType.name,
          fromDB: widget.title,
          maxl: 1,
          mycontroller: title,
          myMaxlength: 50,
          valid: (val) {
            return validInput(val!, 4, 50);
          },
        ),

        CustTextFormWithEdit(
          hint: "???????????? ??????????",
          ourInput: TextInputType.multiline,
          fromDB: widget.title,
          maxl: 4,
          mycontroller: content,
          myMaxlength: 0,
          valid: (val) {
            return validInput(val!, 4, 0);
          },
        ),
        // CustTextFormSign(
        //   ourInput: TextInputType.multiline,
        //   hint: '???????????? ??????????',
        //   maxl: 5,
        //   myMaxlength: 200,
        //   mycontroller: content,
        //   valid: (val) {
        //     return validInput(val!, 4, 200);
        //   },
        //   icon: Icons.details,
        // ),
      ],
    );
  }

  Widget newsImagesNow() {
    return Column(
      children: [
        Text(
          '?????? ?????????? ??????????????',
          style: TextStyle(fontSize: 22, color: AppTheme.appTheme.primaryColor),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.all(2),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(2.0),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 180.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        placeholder: kTransparentImage,
                        image: linkImageRoot + images[index]['img_url'],
                        imageErrorBuilder: (c, o, s) => Image.asset(
                          "assets/AlUyun2.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        placeholderErrorBuilder: (c, o, s) => Image.asset(
                          "assets/AlUyun2.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        // repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (mounted) {
                          AwesomeDialog(
                                  context: context,
                                  animType: AnimType.TOPSLIDE,
                                  dialogType: DialogType.QUESTION,
                                  title: '??????????',
                                  desc: '???? ?????? ?????????? ???? ?????????? ??????????',
                                  btnOkOnPress: () async {
                                    var response = await _curd
                                        .postRequest(linkDeleteImages, {
                                      "id": images[index]['id'],
                                      "ns_img": images[index]['img_url'],
                                    });
                                    // print(response['status']);

                                    if (response['status'] == 'success') {
                                      if (mounted) {
                                        setState(() {
                                          images.removeAt(index);
                                        });
                                        await AwesomeDialog(
                                          context: context,
                                          animType: AnimType.TOPSLIDE,
                                          dialogType: DialogType.SUCCES,
                                          title: '????????',
                                          desc: '?????? ?????????? ?????????? ??????????',
                                          btnOkOnPress: () {
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          },
                                          btnOkColor: Colors.blue,
                                          btnOkText: '????????',
                                        ).show();
                                      }
                                    } else {
                                      if (mounted) {
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.TOPSLIDE,
                                          dialogType: DialogType.ERROR,
                                          title: '??????',
                                          desc: '???????? ???? ???????? ????????????????',
                                        ).show();
                                      }
                                    }
                                  },
                                  btnOkColor: Colors.red,
                                  btnOkText: '??????',
                                  btnCancelOnPress: () {},
                                  btnCancelColor: Colors.blue,
                                  btnCancelText: '??????????')
                              .show();
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget addNewImages() {
    return Column(
      children: [
        MultiImagePickerView(
          draggable: isAlertSet,
          controller: controller,
          padding: const EdgeInsets.all(10),
        ),
        // IconButton(
        //     onPressed: () => selectImages(),
        //     icon: const Icon(Icons.camera_alt)),
        // GridView.builder(
        //     physics: ScrollPhysics(),
        //     padding: const EdgeInsets.all(2),
        //     scrollDirection: Axis.vertical,
        //     shrinkWrap: true,
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //     ),
        //     itemCount: iamgesList.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return Container(
        //         padding: const EdgeInsets.all(2.0),
        //         child: Stack(
        //           children: [
        //             SizedBox(
        //               width: 200,
        //               height: 200,
        //               child: ClipRRect(
        //                   borderRadius: BorderRadius.circular(8.0),
        //                   child: Image.file(
        //                     File(iamgesList[index].path),
        //                     fit: BoxFit.cover,
        //                   )),
        //             ),
        //             IconButton(
        //                 onPressed: () {
        //                   iamgesList.removeAt(index);
        //                   if (mounted) {
        //   setState(() {});
        // }
        //                 },
        //                 icon: const Icon(
        //                   Icons.delete,
        //                   color: Colors.red,
        //                 )),
        //           ],
        //         ),
        //       );
        //     })
      ],
    );
  }

  Widget buildNewsType(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        children: [
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    '?????? ??????????????',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        '??????',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        '??????????',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        '????????????',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 4,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        '?????????? ????????????????',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 5,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        '?????? ??????????',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    '?????????? ??????????????',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: typeOf,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => typeOf = value!);
                          }
                        },
                      ),
                      const Text(
                        '?????? ??????????????',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: typeOf,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => typeOf = value!);
                          }
                        },
                      ),
                      const Text(
                        '?????????? ???? ????????????',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          widget.direct == true
              ? Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          '???????? ??????????????',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: newsState,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() => newsState = value!);
                                }
                              },
                            ),
                            const Text(
                              '?????? ????????????????',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: newsState,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() => newsState = value!);
                                }
                              },
                            ),
                            const Text(
                              '??????????',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 3,
                              groupValue: newsState,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() => newsState = value!);
                                }
                              },
                            ),
                            const Text(
                              '??????????',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(height: 25),
          Container(
              width: Get.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      '?????????? ?????????? ??????????',
                      style: TextStyle(fontSize: 20),
                    ),

                    // TextButton(
                    //     child: Text(dateTime.toString()),
                    //     onPressed: () => GetUtils.showSheet(context,
                    //             child: buildDatePicker(), onClicked: () {
                    //           Navigator.pop(context);
                    //         })),

                    TextButton(
                      child: changeDate == false
                          ? Text(
                              '${widget.dateEnd.year}-${widget.dateEnd.month}-${widget.dateEnd.day}')
                          : Text(
                              '${dateTimeToUplodeString.year}-${dateTimeToUplodeString.month}-${dateTimeToUplodeString.day}'),
                      onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          actions: [
                            buildDatePicker(),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Done'),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  dateTimeToUplodeString = dateTime;
                                  changeDate = true;
                                });

                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDatePicker() => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
            initialDateTime: dateTime,
            minimumYear: 2021,
            maximumYear: 2100,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (dateTime) => setState(
                  (() => this.dateTime = dateTime),
                )),
      );
  void openWhatsApp(String usph) async {
    var whatsapp = '+966$usph';
    var whatsappUrlAndroid = 'whatsapp://send?phone=$whatsapp';
    var whatsappUrlIos = "https://wa.me/$whatsapp";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappUrlIos))) {
        await launchUrl(Uri.parse(whatsappUrlIos));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('?????????? WhatsApp  ?????? ????????')));
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappUrlAndroid))) {
        await launchUrl(Uri.parse(whatsappUrlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('?????????? WhatsApp  ?????? ????????')));
      }
    }
  }
}

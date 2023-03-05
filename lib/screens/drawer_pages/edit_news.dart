import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:byahmed_eyone/screens/drawer_pages/my_news.dart';
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

class EditNews extends StatefulWidget {
  const EditNews(
      {Key? key,
      required this.title,
      required this.nsid,
      required this.content,
      required this.nsImg})
      : super(key: key);
  final String title;
  final String nsid;

  final String content;
  final String nsImg;
  @override
  State<EditNews> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {
  // late StreamSubscription streamSubscription;

  File? file;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  String imageToDelete = '';
  final List<XFile> iamgesList = [];
  List<File> fileList = [];
  bool isLoading = false;
  bool isImagesLoading = true;
  final Curd curd = Curd();
  int newsOrAds = 0;
  var isDeviceConnected = false;
  var canSendNews = true;
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
          title: 'خطأ',
          // desc: 'تأكد من توفر الإنترنت',
          desc: 'لم يتم التحقق من توفر الصور الإضافية تحقق من توفر الإنترنت',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: 'تحقق من توفر الإنترنت',
          // btnCancelOnPress: () {},
          // btnCancelColor: AppTheme.appTheme.primaryColor,
          // btnCancelText: 'مراسلة الإدارة'
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
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

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
  editNews() async {
    FocusScope.of(context).unfocus();
    final images = controller.images; // return Iterable<ImageFile>
    for (final image in images) {
      if (image.hasPath) files.add(File(image.path!));
    }

    if (file == null &&
        title.text == widget.title &&
        content.text == widget.content &&
        files.isEmpty) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.ERROR,
          // dialogColor: AppTheme.appTheme.primaryColor,
          title: 'عذراً',
          desc: 'لم تقم بتعديل أي بيانات',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: 'خروج',
        ).show();
      }
    } else {
      if (formstate.currentState!.validate()) {
        if (canSendNews == true) {
          for (int i = 0; i < iamgesList.length; i++) {
            files.add(File(iamgesList[i].path));
          }
          canSendNews = false;

          var moreImages = 'no';
          if (files.isNotEmpty) {
            moreImages = 'yes';
          }
          isLoading = true;
          if (mounted) {
            setState(() {});
          }
          for (var i = 0; i < iamgesList.length; i++) {
            fileList.add(File(iamgesList[i].path));
          }

          dynamic response;
          if (file == null) {
            response = await curd.postRequestWithFilesWithOutFile(
                linkEditNews,
                {
                  'ns_title': title.text,
                  'ns_txt': content.text,
                  'nsid': widget.nsid,
                  'moreImg': moreImages,
                  'changeImage': 'no',
                  'oldImageName': widget.nsImg
                },
                files);
          } else {
            response = await curd.postRequestWithFiles(
                linkEditNews,
                {
                  'ns_title': title.text,
                  'ns_txt': content.text,
                  'nsid': widget.nsid,
                  'moreImg': moreImages,
                  'changeImage': 'yes',
                  'oldImageName': widget.nsImg
                },
                file,
                files);
          }

          isLoading = false;
          canSendNews = true;
          if (mounted) {
            setState(() {});
          }

          if (response == 'Error') {
            if (mounted) {
              AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.ERROR,
                // dialogColor: AppTheme.appTheme.primaryColor,
                title: 'خطأ',
                desc: 'تأكد من توفر الإنترنت',
                btnOkOnPress: () {},
                btnOkColor: Colors.blue,
                btnOkText: 'خروج',
                // btnCancelOnPress: () {},
                // btnCancelColor: AppTheme.appTheme.primaryColor,
                // btnCancelText: 'مراسلة الإدارة'
              ).show();
            }
          } else {
            if (response['status'] == 'success') {
              if (mounted) {
                await AwesomeDialog(
                  context: context,
                  animType: AnimType.TOPSLIDE,
                  dialogType: DialogType.SUCCES,
                  title: 'نجاح',
                  desc: 'الخبر قيد المراجعة من قبل الإدارة',
                  btnOkOnPress: () {},
                  btnOkColor: Colors.blue,
                  btnOkText: 'خروج',
                ).show();
              }
              Get.back();
              Get.off(
                () => const MyNews(
                  title: 'أخباري',
                  type: '1',
                ),
              );
            } else {
              if (mounted) {
                await AwesomeDialog(
                  context: context,
                  animType: AnimType.TOPSLIDE,
                  dialogType: DialogType.ERROR,
                  title: 'خطأ',
                  desc: 'تأكد من توفر الإنترنت',
                  btnOkOnPress: () {},
                  btnOkColor: Colors.blue,
                  btnOkText: 'Ok',
                ).show();
              }
              canSendNews = true;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: Text(widget.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.appTheme.primaryColor,
        label: const Text('تعديل الخبر'),
        onPressed: () => editNews(),
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
              ? SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.file(
                    file!,
                    fit: BoxFit.contain,
                  ),
                )
              : SizedBox(
                  width: 200,
                  height: 200,
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
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
                    'متصفح الصور',
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
                      'الكاميرا',
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
        CustTextFormWithEdit(
          hint: "عنوان الخبر",
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
          hint: "تفاصيل الخبر",
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
        //   hint: 'تفاصيل الخبر',
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
          'صور الخبر الحالية',
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

                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        placeholder: kTransparentImage,
                        image: linkImageRoot + images[index]['img_url'],
                        imageErrorBuilder: (c, o, s) => Image.asset(
                          "assets/AlUyun2.png",
                          fit: BoxFit.cover,
                        ),
                        placeholderErrorBuilder: (c, o, s) => Image.asset(
                          "assets/AlUyun2.png",
                          fit: BoxFit.cover,
                        ),
                        // repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        AwesomeDialog(
                                context: context,
                                animType: AnimType.TOPSLIDE,
                                dialogType: DialogType.QUESTION,
                                title: 'تحذير',
                                desc: 'هل أنت متأكد من عملية الحذف',
                                btnOkOnPress: () async {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = true;
                                      canSendNews = false;
                                    });
                                  }
                                  var response =
                                      await curd.postRequest(linkDeleteImages, {
                                    "id": images[index]['id'],
                                    "ns_img": images[index]['img_url'],
                                  });
                                  // print(response['status']);
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                      canSendNews = true;
                                    });
                                  }
                                  if (response == 'Error') {
                                    canSendNews = true;
                                    isLoading = false;
                                    if (mounted) {
                                      setState(() {});

                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.TOPSLIDE,
                                        dialogType: DialogType.ERROR,
                                        // dialogColor: AppTheme.appTheme.primaryColor,
                                        title: 'خطأ',
                                        desc: 'تأكد من توفر الإنترنت',
                                        btnOkOnPress: () {},
                                        btnOkColor: Colors.blue,
                                        btnOkText: 'خروج',
                                        // btnCancelOnPress: () {},
                                        // btnCancelColor: AppTheme.appTheme.primaryColor,
                                        // btnCancelText: 'مراسلة الإدارة'
                                      ).show();
                                    }
                                  } else {
                                    if (response['status'] == 'success') {
                                      if (mounted) {
                                        await AwesomeDialog(
                                          context: context,
                                          animType: AnimType.TOPSLIDE,
                                          dialogType: DialogType.SUCCES,
                                          title: 'نجاح',
                                          desc: 'تمت عملية الحذف بنجاح',
                                          btnOkOnPress: () {
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          },
                                          btnOkColor: Colors.blue,
                                          btnOkText: 'خروج',
                                        ).show();
                                        if (mounted) {
                                          setState(() {
                                            images.removeAt(index);
                                          });
                                        }
                                      }
                                    } else {
                                      if (mounted) {
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.TOPSLIDE,
                                          dialogType: DialogType.ERROR,
                                          title: 'خطأ',
                                          desc: 'تأكد من توفر الإنترنت',
                                        ).show();
                                      }
                                    }
                                  }
                                },
                                btnOkColor: Colors.red,
                                btnOkText: 'حذف',
                                btnCancelOnPress: () {},
                                btnCancelColor: Colors.blue,
                                btnCancelText: 'تراجع')
                            .show();
                        if (mounted) {
                          setState(() {});
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
      ],
    );
  }
}

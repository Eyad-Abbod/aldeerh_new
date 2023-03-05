import 'dart:async';
import 'dart:io';
import 'package:byahmed_eyone/main.dart';
import 'package:byahmed_eyone/screens/home_screen.dart';
import 'package:byahmed_eyone/shared_ui/policy_and_terms.dart';
import 'package:byahmed_eyone/utilities/crud.dart';
import 'package:byahmed_eyone/utilities/link_app.dart';
import 'package:byahmed_eyone/shared_ui/customtextfield.dart';
import 'package:byahmed_eyone/utilities/app_theme.dart';
import 'package:byahmed_eyone/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNews extends StatefulWidget {
  const AddNews({Key? key, required this.title, required this.type})
      : super(key: key);
  final String title;
  final String type;
  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  // late StreamSubscription streamSubscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool canSendNews = true;
  bool agree = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    content.dispose();
    title.dispose();
    super.dispose();
  }

  final controller = MultiImagePickerController(
    maxImages: 6,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );
  File? file;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  final List<XFile> _iamgesList = [];
  bool isLoading = false;
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

  addNews() async {
    FocusScope.of(context).unfocus();
    if (formstate.currentState!.validate()) {
      if (canSendNews == true) {
        if (agree == false) {
          showToast("يجب الموافقة على الشروط والأحكام");
        } else if (file == null) {
          showToast("بجب إضافة صورة للخبر");
        } else {
          canSendNews = false;
          List<File> files = [];
          for (int i = 0; i < _iamgesList.length; i++) {
            files.add(File(_iamgesList[i].path));
          }

          final images = controller.images; // return Iterable<ImageFile>
          for (final image in images) {
            if (image.hasPath) files.add(File(image.path!));
          }
          var moreImages = 'no';
          if (files.isNotEmpty) {
            moreImages = 'yes';
          }
          isLoading = true;
          if (mounted) {
            setState(() {});
          }

          var response = await _curd.postRequestWithFiles(
              linkAddNews,
              {
                'ns_title': title.text,
                'ns_txt': content.text,
                'usid': sharedPref.getString('usid'),
                'ns_ty': widget.type,
                'moreImg': moreImages,
              },
              file!,
              files);
          isLoading = false;
          if (mounted) {
            setState(() {});
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
                        // dialogColor: AppTheme.appTheme.primaryColor,
                        title: 'نجاح',
                        desc: 'الخبر قيد المراجعة من قبل الإدارة',
                        btnOkOnPress: () => openWhatsApp(),
                        btnOkColor: AppTheme.appTheme.primaryColor,
                        btnOkText: 'مراسلة الإدارة',
                        btnCancelOnPress: () =>
                            Get.offAll(() => const HomeScreen()),
                        btnCancelColor: Colors.blue,
                        btnCancelText: 'خروج')
                    .show();
              }
              Get.to(() => const HomeScreen());
            } else {
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
            }
          }
        }
      }
    }
  }

  void selectImages() async {
    try {
      final List<XFile> selectedImages = await ImagePicker().pickMultiImage();
      if (selectedImages.isNotEmpty) {
        _iamgesList.addAll(selectedImages);
      }

      debugPrint('Images list lingth :${_iamgesList.length}');
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    if (mounted) {
      setState(() {});
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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.appTheme.primaryColor,
        label: const Text('أرسل الخبر'),
        onPressed: () async => await addNews(),
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
                    Card(
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
                              : Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Center(child: Text('اختر صورة')),
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
                                  onPressed: () =>
                                      pickImage(ImageSource.gallery),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.appTheme
                                        .primaryColor, // Background color
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
                                    onPressed: () =>
                                        pickImage(ImageSource.camera),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.appTheme
                                          .primaryColor, // Background color
                                    ),
                                    child: const Text(
                                      'الكاميرا',
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        children: [
                          CustTextFormSign(
                            ourInput: TextInputType.name,
                            hint: "عنوان الخبر",
                            maxl: 1,
                            mycontroller: title,
                            myMaxlength: 50,
                            valid: (val) {
                              return validInput(val!, 4, 50);
                            },
                            icon: Icons.ac_unit,
                          ),
                          CustTextFormSign(
                            ourInput: TextInputType.multiline,
                            hint: 'تفاصيل الخبر',
                            maxl: 5,
                            myMaxlength: 0,
                            mycontroller: content,
                            valid: (val) {
                              return validInput(val!, 4, 1000);
                            },
                            icon: Icons.ac_unit,
                          ),
                          Center(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: agree,
                                  onChanged: (newValue) {
                                    if (mounted) {
                                      setState(() => agree = newValue!);
                                    }
                                  },
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.to(() => const PolicyAndTerms()),
                                  child: const Text(
                                    'الموافقة على الشروط والأحكام',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    MultiImagePickerView(
                      draggable: isAlertSet,
                      controller: controller,
                      padding: const EdgeInsets.all(10),
                    ),
                  ],
                ),
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
    // Widget buildMessageButton() => FloatingActionButton.extended(
    //     icon: Icon(Icons.message), onPressed: () {}, label: Text('أرسل الخبر'));
  }

  void openWhatsApp() async {
    var whatsapp = phoneNumber;
    var whatsappUrlAndroid = 'whatsapp://send?phone=$whatsapp';
    var whatsappUrlIos = "https://wa.me/$whatsapp";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappUrlIos))) {
        await launchUrl(Uri.parse(whatsappUrlIos));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تطبيق WhatsApp  غير مثبت')));
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappUrlAndroid))) {
        await launchUrl(Uri.parse(whatsappUrlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تطبيق WhatsApp  غير مثبت')));
      }
    }
  }

  void showToast(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0);

  // showDilogBox() => showCupertinoDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //           title: Text('لا يتوفر إتضال بالإنترنت'),
  //           content: Text('أعد الإتصال بالإنترنت'),
  //           actions: [
  //             TextButton(
  //                 onPressed: () async {
  //                   Navigator.pop(context, 'Cancel');
  //                   setState(() => isAlertSet = false);
  //                   isDeviceConnected =
  //                       await InternetConnectionChecker().hasConnection;
  //                   if (!isDeviceConnected) {
  //                     showDilogBox();
  //                     setState(() => isAlertSet = true);
  //                   }
  //                 },
  //                 child: Text('OK'))
  //           ],
  //         ));
}

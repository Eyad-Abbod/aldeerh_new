import 'dart:convert';

import 'package:byahmed_eyone/main.dart';
import 'package:byahmed_eyone/screens/shared_ui/news_details.dart';
import 'package:byahmed_eyone/utilities/app_theme.dart';
import 'package:byahmed_eyone/utilities/crud.dart';
// import 'package:flutter/cupertino.dart';
import 'package:byahmed_eyone/utilities/link_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;

class NewsFromNotifications extends StatefulWidget {
  final String newsID;
  const NewsFromNotifications({super.key, required this.newsID});

  @override
  State<NewsFromNotifications> createState() => _NewsFromNotificationsState();
}

class _NewsFromNotificationsState extends State<NewsFromNotifications> {
  List news = [];
  bool isLoadRunning = true;
  bool isConnected = true;
  final Curd curd = Curd();
  @override
  void initState() {
    firstLoad();
    super.initState();
  }

  seenNews() async {
    if (sharedPref.getString("usid") == null) {
      curd.postRequests(
        linkVisitNewsToDay,
        {
          'userId': sharedPref.getString('shared_ID'),
          'newsId': widget.newsID,
        },
      );

      // if (response['status'] == 'success') {
      //   print('Add Shared_Id');
      // } else {
      //   print('No Shared_Id');
      // }
    } else {
      curd.postRequests(
        linkVisitNewsToDay,
        {
          'userId': sharedPref.getString('usid'),
          'newsId': widget.newsID,
        },
      );

      // if (response['status'] == 'success') {
      //   print('Add Shared_Id');
      // } else {
      //   print('No Shared_Id');
      // }
    }
  }

  void firstLoad() async {
    if (mounted) {
      setState(() {
        isLoadRunning = true;
      });
    }

    try {
      final res = await http
          .get(Uri.parse("$linkNewsFromNotifications?nsid=${widget.newsID}"));
      if (mounted) {
        setState(() {
          news = json.decode(res.body);
        });
      }
    } catch (e) {
      isConnected = false;
      if (mounted) {
        // showDilogBox();
      }
      debugPrint("Something went wrong1");
    }
    if (mounted) {
      setState(() {
        isLoadRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoadRunning == true
          ? Container(
              color: Colors.white,
              child: Center(
                  child: SpinKitSpinningLines(
                color: AppTheme.appTheme.primaryColor,
                size: 100.0,
              )))
          : news.isEmpty
              ? Scaffold(
                  appBar: AppBar(
                    title: const Text(''),
                    backgroundColor: AppTheme.appTheme.primaryColor,
                  ),
                  body: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off,
                          color: AppTheme.appTheme.primaryColor, size: 44),
                      Text(
                        'لا يوجد اتصال بالإنترنت',
                        style: TextStyle(
                          fontSize: 22,
                          color: AppTheme.appTheme.primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          label: const Text('اعادة تحميل'), // <-- Text
                          backgroundColor: AppTheme.appTheme.primaryColor,
                          icon: const Icon(
                            // <-- Icon
                            Icons.refresh,
                            size: 24.0,
                          ),
                          onPressed: () => firstLoad(),
                        ),
                      ),
                    ],
                  )),
                )
              : NewsDetails(
                  type: news[0]['ns_ty'],
                  title: news[0]['ns_title'],
                  content: news[0]['ns_txt'],
                  nsImg: news[0]['ns_img'],
                  name: news[0]['name'],
                  date: news[0]['ns_da_st'],
                  nsid: news[0]['nsid'],
                  usty: '1',
                  usph: news[0]['usph'].substring(1),
                  viewsCount:
                      news[0]['seen'].toString().split(',').length.toString(),
                  commentsCount: news[0]['commentsCount'],
                ),
    );
    // return Scaffold(
    //   appBar: AppBar(title: Text(news[0]['ns_title'])),
    //   body: Container(
    //     child: Text(
    //       news[0]['ns_title'],
    //     ),
    //   ),
    // );
  }

  // showDilogBox() => showCupertinoDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: const Text('لا يتوفر إتصال بالإنترنت'),
  //         content: const Text('أعد الإتصال بالإنترنت'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => firstLoad(),
  //             child: Text(
  //               'OK',
  //               style: TextStyle(color: AppTheme.appTheme.primaryColor),
  //             ),
  //           )
  //         ],
  //       ),
  //     );
}

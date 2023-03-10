import 'dart:convert';

import 'package:byahmed_eyone/admin/operations/add.dart';
import 'package:byahmed_eyone/admin/operations/ads_news.dart';
import 'package:byahmed_eyone/admin/operations/comments_admin.dart';
import 'package:byahmed_eyone/admin/operations/familes.dart';
import 'package:byahmed_eyone/admin/operations/news_screen.dart';
import 'package:byahmed_eyone/admin/operations/persons.dart';
import 'package:byahmed_eyone/admin/operations/shared.dart';
import 'package:byahmed_eyone/admin/operations/users/users_all.dart';
import 'package:byahmed_eyone/admin/operations/view_suggestion.dart';
import 'package:byahmed_eyone/screens/home_screen.dart';
import 'package:byahmed_eyone/screens/search_news.dart';
import 'package:byahmed_eyone/utilities/app_theme.dart';
import 'package:byahmed_eyone/utilities/crud.dart';
import 'package:byahmed_eyone/utilities/link_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String a = '';
  bool isLoadRunning = false;
  int visiter = 0;
  int visiterRecorde = 0;
  int visiterUnRecorde = 0;

  @override
  void initState() {
    visitedToDay();
    super.initState();
  }

  final Curd curd = Curd();

  List<String> seenList = [];
  visitedToDay() async {
    if (mounted) {
      setState(() {
        isLoadRunning = true;
      });
    }
    try {
      final res = await http.get(Uri.parse(linkVisitedToDay));

      if (mounted) {
        setState(() {
          a = json.decode(res.body);

          List aa = a.split(',');
          for (var i = 0; i < aa.length; i++) {
            if (aa[i].substring(0, 1) == '0') {
              visiterUnRecorde = visiterUnRecorde + 1;
            } else {
              visiterRecorde = visiterRecorde + 1;
            }
            visiter = visiter + 1;
          }

          isLoadRunning = false;
        });
      }
    } catch (e) {
      // _isConnected = false;
      if (mounted) {
        setState(() {
          isLoadRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("???????? ????????????"),
        actions: [
          IconButton(
            onPressed: () {
              // showSearch(context: context, delegate: SearchUser());
              Get.to(() => const SearchNews(
                    isAdmin: 6,
                  ));
            },
            icon: const Icon(Icons.search_sharp),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.offAll(() => const HomeScreen()),
          backgroundColor: AppTheme.appTheme.primaryColor,
          child: const Text('????????')),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: Text('data'),
        child: SizedBox(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            children: [
              Card(
                color: Colors.greenAccent,
                elevation: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 30,
                    ),
                    isLoadRunning
                        ? const Center(child: CupertinoActivityIndicator())
                        : Text('???????????????? ??????????: $visiter',
                            style: const TextStyle(fontSize: 20)),
                    isLoadRunning
                        ? const Center(child: CupertinoActivityIndicator())
                        : Text('????????????????: $visiterRecorde'),
                    isLoadRunning
                        ? const Center(child: CupertinoActivityIndicator())
                        : Text('?????????? ????????????: $visiterUnRecorde')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          children: [
            InkWell(
              onTap: () => Get.to(() => const NewsScreen()),
              child: Card(
                elevation: 2,
                color: Colors.deepPurpleAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.newspaper),
                    Text(
                      '??????????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const PersonsAdminScreen()),
              child: Card(
                elevation: 2,
                color: Colors.amberAccent.shade700,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.newspaper),
                    Text(
                      '????????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const SharedAdminScreen()),
              child: Card(
                elevation: 2,
                color: Colors.cyan,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.newspaper),
                    Text(
                      '??????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const FamiliesAdminScreen()),
              child: Card(
                elevation: 2,
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.newspaper),
                    Text(
                      '?????? ??????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // InkWell(
            //   onTap: () => Get.to(() => const NewsStateScreen()),
            //   child: Card(
            //     elevation: 2,
            //     color: Colors.amber,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.newspaper),
            //         Text('????????????????'),
            //       ],
            //     ),
            //   ),
            // ),
            // InkWell(
            //   onTap: () => Get.to(() => const NewsStateScreen()),
            //   child: Card(
            //     elevation: 2,
            //     color: Colors.green,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.newspaper),
            //         Text('??????????????????'),
            //       ],
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () => Get.to(() => const AdsNewsAdminScreen()),
              child: Card(
                elevation: 2,
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.newspaper),
                    Text(
                      '??????????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => Get.to(() => const ViewSuggestion()),
              child: Card(
                color: Colors.green.shade400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.newspaper),
                    Text(
                      '??????????????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Card(
            //   color: Colors.red.shade400,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const [
            //       Icon(Icons.person),
            //       Text('??????????????'),
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () => Get.to(() => const CommentsAdmin()),
              child: Card(
                elevation: 2,
                color: Colors.red.shade400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.comment),
                    Text(
                      '??????????????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const Users()),
              child: Card(
                elevation: 2,
                color: Colors.purple.shade400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_box_outlined),
                    Text(
                      '????????????????????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () => Get.to(() => const AddNewsAdmin()),
              child: Card(
                elevation: 2,
                color: Colors.blue.shade400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_box_outlined),
                    Text(
                      '?????????? ??????',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Card(
            //   color: Colors.lightGreenAccent,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const [
            //       Icon(Icons.newspaper),
            //       Text('????????????????????'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

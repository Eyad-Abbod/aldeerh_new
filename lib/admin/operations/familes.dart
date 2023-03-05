import 'package:byahmed_eyone/admin/operations/news_operations/delete_news.dart';
import 'package:byahmed_eyone/admin/operations/news_operations/new_news.dart';
import 'package:byahmed_eyone/admin/operations/news_operations/sheard_news.dart';
import 'package:byahmed_eyone/screens/search_news.dart';
import 'package:byahmed_eyone/utilities/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamiliesAdminScreen extends StatefulWidget {
  const FamiliesAdminScreen({Key? key}) : super(key: key);

  @override
  State<FamiliesAdminScreen> createState() => _FamiliesAdminScreenState();
}

class _FamiliesAdminScreenState extends State<FamiliesAdminScreen> {
  int index = 0;

  final screens = [
    const NewNewsOperations(newsType: 5),
    const SheardNewsOperations(newsType: 5),
    const DeletedNewsOperations(newsType: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("أسر منتجة"),
        actions: [
          IconButton(
            onPressed: () {
              // showSearch(context: context, delegate: SearchUser());
              Get.to(() => const SearchNews(
                    isAdmin: 5,
                  ));
            },
            icon: const Icon(Icons.search_sharp),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.white,
          // labelTextStyle: MaterialStateProperty.all(
          //   TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          // ),
        ),
        child: NavigationBar(
          height: 60,
          // animationDuration: Duration(seconds: 1),
          backgroundColor: Colors.white30,
          // backgroundColor: AppTheme.appTheme.primaryColor,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.newspaper_outlined,
                color: Colors.blue,
                size: 30,
              ),
              icon: Icon(
                Icons.newspaper_sharp,
                color: Colors.grey,
              ),
              label: 'قيد المراجعة',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.newspaper_sharp,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.newspaper,
                color: Color.fromARGB(255, 20, 192, 29),
                size: 30,
              ),
              label: 'الأخبار المنشورة',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
              label: 'الأخبار المحذوفة',
            ),
          ],
        ),
      ),
    );
  }
}

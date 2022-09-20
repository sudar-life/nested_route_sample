import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nested_route_sample/src/components/message_popup.dart';
import 'package:nested_route_sample/src/pages/explore/explore.dart';
import 'package:nested_route_sample/src/pages/explore/explore_detail_page.dart';
import 'package:nested_route_sample/src/pages/home/detail_page.dart';
import 'package:nested_route_sample/src/pages/home/home.dart';
import 'package:nested_route_sample/src/pages/setting/setting.dart';
import 'package:nested_route_sample/src/root.dart';

enum PageName {
  HOME('/home'),
  EXPLORE('/explore'),
  SETTING('/setting');

  const PageName(this.path);
  final String path;
}

class RouteController extends GetxController {
  static RouteController get to => Get.find();
  RxInt rootPageIndex = 0.obs;
  int homeNavKey = 0;
  int exploreNavKey = 1;
  int settingNavKey = 2;

  List<int> bottomHistory = [0];

  static List<GetPage> routs = [
    GetPage(name: '/', page: () => Root()),
    GetPage(name: '/home', page: () => const Home()),
    GetPage(name: '/detailPage', page: () => const DetailPage()),
    GetPage(name: '/explore', page: () => const Explore()),
    GetPage(name: '/explore/detailPage', page: () => const ExploreDetailPage()),
    GetPage(name: '/setting', page: () => const Setting()),
  ];

  RxBool isCategoryPageOpen = false.obs;

  void changeRootPageIndex(int value, {hasGesture = true}) {
    rootPageIndex(value);
    if (!hasGesture) return;
    if (bottomHistory.last != value) {
      bottomHistory.add(value);
    }
  }

  Future<bool> onWillPop() async {
    if (bottomHistory.length == 1 &&
        !Get.keys[rootPageIndex.value]!.currentState!.canPop()) {
      await showDialog(
        context: Get.context!,
        builder: (context) => MessagePopup(
          message: '종료하시겠습니까?',
          okCallback: () {
            exit(0);
          },
          cancelCallback: Get.back,
          title: '시스템',
        ),
      );
      return false;
    } else {
      var page = PageName.values[bottomHistory.last];
      setCategoryPage(false);

      var value = await Get.keys[rootPageIndex.value]!.currentState!.maybePop();
      if (value) return false;

      bottomHistory.removeLast();
      var index = bottomHistory.last;
      changeRootPageIndex(index, hasGesture: false);
      return false;
    }
  }

  void setCategoryPage(bool ck) {
    isCategoryPageOpen(ck);
  }

  void back() {
    setCategoryPage(false);
    onWillPop();
  }

  Route<dynamic> onGenerateRoute(currentRoute, int navKey) {
    var finds = routs.where((route) => route.name == currentRoute.name);
    if (currentRoute.name == '/') {
      if (!Get.keys[rootPageIndex.value]!.currentState!.canPop()) {
        finds = RouteController.routs
            .where((route) => route.name == PageName.values[navKey].path);
      }
    }
    var thisRoute = finds.first;
    return GetPageRoute(routeName: thisRoute.name, page: thisRoute.page);
  }
}

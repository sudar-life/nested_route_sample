import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nested_route_sample/src/controller/root_controller.dart';

class Root extends GetView<RouteController> {
  Root({Key? key}) : super(key: key);

  Widget _buildOffstageNavigator(int navKey) {
    return Offstage(
      offstage: controller.rootPageIndex.value != navKey,
      child: Navigator(
        key: Get.nestedKey(navKey),
        onGenerateRoute: (currentRoute) {
          return controller.onGenerateRoute(currentRoute, navKey);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            leading: controller.isCategoryPageOpen.value
                ? GestureDetector(
                    onTap: controller.back,
                    child: const Icon(Icons.arrow_back_ios),
                  )
                : Container(),
            centerTitle: true,
            title: controller.isCategoryPageOpen.value
                ? const Text('Music Menu')
                : const Text('Nested Route Sample'),
          ),
          body: Stack(
            children: [
              _buildOffstageNavigator(0),
              _buildOffstageNavigator(1),
              _buildOffstageNavigator(2),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.rootPageIndex.value,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: controller.changeRootPageIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.grey),
                label: 'home',
                activeIcon: Icon(Icons.home, color: Colors.blue),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore, color: Colors.grey),
                label: 'explore',
                activeIcon: Icon(Icons.explore, color: Colors.blue),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, color: Colors.grey),
                label: 'settings',
                activeIcon: Icon(Icons.settings, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

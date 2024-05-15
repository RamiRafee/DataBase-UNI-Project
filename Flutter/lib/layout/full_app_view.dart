import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/shop_layout.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/platforms/adaptive_layout_widget.dart';
import 'package:e_commerce_app/platforms/custom_drawer.dart';
import 'package:e_commerce_app/platforms/desktop_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/foundation.dart';

class FullView extends StatefulWidget {
  const FullView({super.key});

  @override
  State<FullView> createState() => _FullViewState();
}

class _FullViewState extends State<FullView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return kIsWeb
            ? Scaffold(
          key: scaffoldKey,
          appBar: MediaQuery.sizeOf(context).width < SizeConfig.tablet
              ? AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFFAFAFA),
            leading: IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu)),
          )
              : null,
          backgroundColor: const Color(0xFFF7F9FA),
          drawer: MediaQuery.sizeOf(context).width < SizeConfig.tablet
              ? const CustomDrawer()
              : null,
          body: AdaptiveLayout(
            mobileLayout: (context) => const ShopLayoutScreen(),
            tabletLayout: (context) => const DashboardDesktopLayout(),
            desktopLayout: (context) => const DashboardDesktopLayout(),
          ),
        )
            : const ShopLayoutScreen();
      },
    );
  }
}

class SizeConfig {
  static const double desktop = 1200;
  static const double tablet = 800;

  static late double width, height;

  static init(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
  }
}

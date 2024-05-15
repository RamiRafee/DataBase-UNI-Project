import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/models/drawer_item_model.dart';
import 'package:e_commerce_app/platforms/active_and_inactive_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:smart_parking/platforms/utils/app_styles.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {super.key, required this.drawerItemModel, required this.isActive});

  final DrawerItemModel drawerItemModel;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return isActive
            ? ActiveDrawerItem(drawerItemModel: drawerItemModel)
            : InActiveDrawerItem(drawerItemModel: drawerItemModel);
      },
    );
  }
}

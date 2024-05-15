import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/models/drawer_item_model.dart';
import 'package:e_commerce_app/modules/brands/brands_screen.dart';
import 'package:e_commerce_app/modules/frauds/fraud_screen.dart';
import 'package:e_commerce_app/modules/power_bi/power_bi_screen.dart';
import 'package:e_commerce_app/modules/power_bi_frame/power_bi_frame.dart';
import 'package:e_commerce_app/platforms/drawer_item.dart';
import 'package:e_commerce_app/platforms/utils/app_images.dart';
import 'package:e_commerce_app/shared/components/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../modules/users_state/users_data.dart';
import 'dashboard_layout.dart';

class DrawerItemsListView extends StatefulWidget {
   const DrawerItemsListView({
    super.key,
  });

  @override
  State<DrawerItemsListView> createState() => _DrawerItemsListViewState();
}

class _DrawerItemsListViewState extends State<DrawerItemsListView> {
  int activeIndex = 0;

  final List<DrawerItemModel> items = [
    const DrawerItemModel(title: 'Product', image: Assets.imagesDashboard),
    const DrawerItemModel(title: 'Fraud Product', image: Assets.imagesMyTransctions),
    const DrawerItemModel(title: 'Power BI', image: Assets.imagesStatistics),
    const DrawerItemModel(title: 'Brands', image: Assets.imagesWalletAccount),
    const DrawerItemModel(title: 'Users', image: Assets.imagesDashboard),
    const DrawerItemModel(title: 'Power BI Frame', image: Assets.imagesStatistics),

    //const DrawerItemModel(title: 'Search in users', image: Assets.imagesSearch),
    //const DrawerItemModel(title: 'Users', image: Assets.imagesAvatar1),
    // const DrawerItemModel(
    //     title: 'My Investments', image: Assets.imagesMyInvestments),
  ];

  List<Widget> webWidget =[
    const DashboardDetails(),
    const FraudScreen(),
    const PowerBiScreen(),
    const BrandsScreen(),
    const UsersDataScreen(),
    const PowerBiFrameScreen(),

    //UserSearchScreen(),
  ];

  int currentIndex =0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return  SliverList.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                ShopCubit.get(context).changeDrawerIndex(index);
                currentIndex = ShopCubit.get(context).drawerIndex;
                adminWidget = webWidget[currentIndex];

                //activeIndex = currentIndex;
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: DrawerItem(
                  drawerItemModel: items[index],
                  isActive: index == currentIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

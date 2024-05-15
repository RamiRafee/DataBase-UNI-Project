import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';
import 'package:e_commerce_app/models/drawer_item_model.dart';
import 'package:e_commerce_app/models/user_info_model.dart';
import 'package:e_commerce_app/platforms/active_and_inactive_item.dart';
import 'package:e_commerce_app/platforms/drawer_items_list_view.dart';
import 'package:e_commerce_app/platforms/user_info_list_tile.dart';
import 'package:e_commerce_app/platforms/utils/app_images.dart';
import 'package:e_commerce_app/shared/components/constants.dart';
import 'package:flutter/material.dart';


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state){},
      builder: (context , state){
        //var cubit = ShopCubit.get(context);

        return ConditionalBuilder(
          condition: true,
          builder: (context) => Container(
            width: MediaQuery.sizeOf(context).width * .7,
            color: const Color.fromRGBO(255, 255, 255, 1),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                    child: UserInfoListTile(
                      userInfoModel: UserInfoModel(
                        image: Assets.imagesAvatar3,
                        title: 'Dashboard',
                        subTitle: 'Admin',
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 8,
                  ),
                ),
                const DrawerItemsListView(),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const Expanded(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          logOut(context);
                        },
                        child: const InActiveDrawerItem(
                          drawerItemModel: DrawerItemModel(
                              title: 'Logout account', image: Assets.imagesLogout),
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          fallback: (context)=> const Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}

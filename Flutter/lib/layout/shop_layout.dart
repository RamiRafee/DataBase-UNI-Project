import 'package:e_commerce_app/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';


class ShopLayoutScreen extends StatelessWidget {
  const ShopLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates >(
      listener: (context , state) {},
      builder: (context,state){
        var cubit = ShopCubit.get(context);

        return Scaffold(
          drawer: Drawer(child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [

            TextButton(onPressed: (){logOut(context);}, child: const Text('Logout'))
          ],),),
          appBar: AppBar(
            title: const Text('ShoeShack'),
            actions: [
              IconButton(
                  onPressed: (){
                    //cubit.getHomeData();
                    cubit.goToSearch(context);
                    //navigateTo(context, SearchScreen());
                  }, icon: const Icon(Icons.search))
            ],
          ),
          body: cubit.bottomScreen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.apps),
                  label: 'Brands'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'add '
              ),

              BottomNavigationBarItem(
                  icon: Icon(Icons.add_shopping_cart_outlined),
                  label: 'Chart'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'Orders'
              ),
            ],
            onTap: (index){cubit.changeCurrentIndex(index , context);},
            currentIndex: cubit.currentIndex,
          ),
        );
      },
    );
  }
}

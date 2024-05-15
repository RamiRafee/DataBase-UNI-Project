import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:e_commerce_app/shared/components/components.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/layout/states.dart';

class UsersDataScreen extends StatefulWidget {
  const UsersDataScreen({super.key});

  @override
  State<UsersDataScreen> createState() => _UsersDataScreenState();
}

class _UsersDataScreenState extends State<UsersDataScreen> {
  int? selectedIndex;
  Set<int> _selectedIndices = Set<int>();

  @override
  Widget build(BuildContext context) {
    var cubit = ShopCubit.get(context);

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessDetectionStates){
          openDetectedSheet(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Users Data'),
              actions: [
                IconButton(
                    onPressed: (){
                      cubit.goToUserSearch(context);
                    }, icon: const Icon(Icons.search)),
                const SizedBox(width: 20,),
                IconButton(
                    onPressed: (){
                      cubit.adminBotDetection(_selectedIndices.toList());
                      //_selectedIndices = Set<int>();

                    }, icon: const Icon(Icons.check_box_outlined)),
              ],
            ),
            body: ConditionalBuilder(
              condition: cubit.getUserDefault != null,
              builder: (context) => SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: DataTable(
                        columns: columnTable,
                        rows: List.generate(cubit.rowTable.length, (index) {
                          return DataRow(
                            selected: _selectedIndices.contains(index),
                            onSelectChanged: (selected) {
                              setState(() {
                                if (selected!) {
                                  _selectedIndices.add(index);
                                  if (kDebugMode) {
                                    print(_selectedIndices.toList());
                                  }
                                } else {
                                  _selectedIndices.remove(index);
                                }
                              });
                            },
                            cells: cubit.rowTable[index].cells,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              fallback: (context) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'There is nothing to show',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


List<DataColumn> columnTable = <DataColumn>[
  const DataColumn(
    label: Text('Id' , style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
  ),
  const DataColumn(
    label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
  ),
  const DataColumn(
    label: Text('Sex', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
  ),
   const DataColumn(
    label: Text('Age', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
  ),
];



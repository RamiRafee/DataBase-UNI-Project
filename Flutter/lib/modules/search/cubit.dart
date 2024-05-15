// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:e_commerce_app/models/search_model.dart';
// import 'package:e_commerce_app/modules/search/states.dart';
// import 'package:e_commerce_app/shared/network/remote/dio_helper.dart';
//
//
// class SearchCubit extends Cubit<SearchStates>{
//   SearchCubit() : super(SearchInitialState());
//
//   static SearchCubit get(context) => BlocProvider.of(context);
//
//   SearchModel? model ;
//
//   void search(String? search){
//     emit(SearchLoadingState());
//
//     DioHelper.getData(data: {'action':'brand_search' , 'brand':search}).then((value) {
//       model = searchModelFromJson(value.data);
//       emit(SearchSuccessState());
//     }).catchError((error){
//       //print(error.toString());
//       emit(SearchErrorState());
//     });
//   }
// }
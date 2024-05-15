// import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:e_commerce_app/modules/login/shop_login.dart';
// import 'package:e_commerce_app/shared/components/components.dart';
// import 'package:e_commerce_app/shared/network/local/cache_helper.dart';
//
// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({super.key});
//
//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }
//
// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   var boardController = PageController();
//
//   bool isLast = false;
//
//   List<BoardingModel> boarding = [
//     BoardingModel(
//       body: 'body 1',
//       image: 'assets/images/onboard_1.jpg',
//       title: 'title 1',
//     ),
//     BoardingModel(
//       body: 'body 2',
//       image: 'assets/images/onboard_2.jpg',
//       title: 'title 2',),
//     BoardingModel(
//       body: 'body 3',
//       image: 'assets/images/onboard_3.jpg',
//       title: 'title 3',),
//   ];
//
//   void finishOnBoarding(){
//
//     CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
//       if(value!)     navigateToFinish(context, ShopLoginScreen());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(
//             onPressed: finishOnBoarding,
//             child: const Text('SKIP'),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 controller: boardController,
//                 physics: const BouncingScrollPhysics(),
//                 itemBuilder: (context, index) =>
//                     buildBoardingItem(boarding[index]),
//                 itemCount: boarding.length,
//                 onPageChanged: (int index) {
//                   if (index == boarding.length - 1) {
//                     setState(() {
//                       isLast = true;
//                     });
//                   }
//                   else {
//                     setState(() {
//                       isLast = false;
//                     });
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SmoothPageIndicator(
//                     controller: boardController,
//                     count: boarding.length,
//                     effect: const ExpandingDotsEffect(
//                       dotColor: Colors.grey,
//                       activeDotColor: Colors.blue,
//                       dotHeight: 10,
//                       dotWidth: 10,
//                       spacing: 5,
//                       expansionFactor: 4,
//                     )
//                 ),
//                 const Spacer(),
//                 FloatingActionButton(
//                   onPressed: () {
//                     if (isLast) {
//                       finishOnBoarding();
//                     } else {
//                       boardController.nextPage(
//                           duration: const Duration(
//                             milliseconds: 750,
//                           ),
//                           curve: Curves.fastLinearToSlowEaseIn);
//                     }
//                   },
//                   child: const Icon(Icons.arrow_forward_ios),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildBoardingItem(BoardingModel model) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Image(
//               image: AssetImage(model.image),
//             ),
//           ),
//           Text(
//             model.title,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           Text(
//             model.body,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//         ],
//       );
// }
//
// class BoardingModel {
//   final String image;
//   final String title;
//   final String body;
//   BoardingModel({required this.body, required this.image, required this.title});
// }

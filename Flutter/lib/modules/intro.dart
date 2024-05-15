// import 'package:e_commerce_app/shared/components/components.dart';
// import 'package:flutter/material.dart';
//
// class Intro extends StatelessWidget {
//   const Intro({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var controller = TextEditingController();
//     var key = GlobalKey<FormState>();
//     return Scaffold(
//       appBar: AppBar(),
//       body: Form(
//         key: key,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Set your IP Address',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(),
//             defaultFormField(
//               controller: controller,
//               type: TextInputType.text,
//               onSubmit: (value) {},
//               onChange: (value) {},
//               onTap: (value) {},
//               validate: (String value) {
//                 if (value.isEmpty) {
//                   return 'This field must not be empty';
//                 }
//               },
//               label: 'Your IP Address',
//               prefix: Icons.network_check_outlined,
//             ),
//             const SizedBox(),
//             // defaultButton(function: (){
//             //   if (key.currentState!.validate()) {
//             //     localhost = controller.text;
//             //     print(localhost);
//             //     DioHelper.init();
//             //     navigateToFinish(context, ShopLoginScreen());
//             //   }
//             // }, text: 'go ahead'),
//           ],
//         ),
//       ),
//     );
//   }
// }

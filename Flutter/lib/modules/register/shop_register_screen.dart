import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:e_commerce_app/modules/login/shop_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/modules/register/cubit.dart';
import 'package:e_commerce_app/modules/register/states.dart';
import 'package:e_commerce_app/shared/components/components.dart';

// ignore: must_be_immutable
class ShopRegisterScreen extends StatelessWidget {
  ShopRegisterScreen({super.key});
  int currentStep = 0;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();

  String selectOption ='';
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.registerModel.success!) {
              toast(
                msg: 'Register Successfully \n Login Now',
                state: ToastState.success,
              );
              navigateToFinish(context, ShopLoginScreen());
            } else {
              toast(
                msg: 'error when logging',
                state: ToastState.error,
              );
            }
          }
          else if(state is ShopRegisterErrorState){
            toast(
              msg: 'Connection Error',
              state: ToastState.error,
            );
          }
        },
        builder: (context, state) {
          var cubit = ShopRegisterCubit.get(context);

          return kIsWeb ?Row(
            children: [
              const Expanded(
                flex: 3,
                child: Image(
                  image: AssetImage(
                    'assets/images/shoe.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Register'),
                  ),
                  body: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Register',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Register now to browse our hot offers',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              defaultFormField(
                                onChange: (value) {},
                                onTap: (value) {},
                                onSubmit: (value) {},
                                suffixPressed: () {},
                                controller: usernameController,
                                type: TextInputType.emailAddress,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Username must not be empty';
                                  }
                                },
                                label: 'Username',
                                prefix: Icons.email_outlined,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                  onChange: (value) {},
                                  onTap: (value) {},
                                  controller: passwordController,
                                  type: TextInputType.visiblePassword,
                                  suffix: cubit.suffix,
                                  onSubmit: (value) {},
                                  isPassword: cubit.isPassword,
                                  suffixPressed: () {
                                    cubit.changePasswordVisibility();
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'password is too short';
                                    }
                                  },
                                  label: 'Password',
                                  prefix: Icons.lock_outline),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                onChange: (value) {},
                                onTap: (value) {},
                                onSubmit: (value) {},
                                suffixPressed: () {},
                                controller: ageController,
                                type: TextInputType.number,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Age must not be empty';
                                  }
                                },
                                label: 'Age',
                                prefix: Icons.calendar_month_rounded,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gender',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 20,),
                                  RadioListTile(
                                    title: const Text('Male'),
                                    value: 'M',
                                    groupValue: selectOption,
                                    onChanged: (String? value){
                                      cubit.changeGender(value!);
                                      selectOption = cubit.gender!;
                                      if (kDebugMode) {
                                        print(selectOption);
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 20,),
                                  RadioListTile(
                                    title: const Text('Female'),
                                    value: 'F',
                                    groupValue: selectOption,
                                    onChanged: (String? value){
                                      cubit.changeGender(value!);
                                      selectOption = cubit.gender!;
                                      if (kDebugMode) {
                                        print(selectOption);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ConditionalBuilder(
                                condition: state is! ShopRegisterLoadingState,
                                builder: (context) => defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userRegister(
                                        username: usernameController.text,
                                        password: passwordController.text,
                                        age: ageController.text,
                                        sex: selectOption
                                      );
                                    }
                                  },
                                  text: 'Register',
                                  isUpperCase: true,
                                ),
                                fallback: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ):Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          onChange: (value) {},
                          onTap: (value) {},
                          onSubmit: (value) {},
                          suffixPressed: () {},
                          controller: usernameController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Username must not be empty';
                            }
                          },
                          label: 'Username',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                            onChange: (value) {},
                            onTap: (value) {},
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: cubit.suffix,
                            onSubmit: (value) {},
                            isPassword: cubit.isPassword,
                            suffixPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'password is too short';
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          onChange: (value) {},
                          onTap: (value) {},
                          onSubmit: (value) {},
                          suffixPressed: () {},
                          controller: ageController,
                          type: TextInputType.number,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Age must not be empty';
                            }
                          },
                          label: 'Age',
                          prefix: Icons.calendar_month_rounded,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(width: 20,),
                            RadioListTile(
                              title: const Text('Male'),
                              value: 'M',
                              groupValue: selectOption,
                              onChanged: (String? value){
                                cubit.changeGender(value!);
                                selectOption = cubit.gender!;
                                if (kDebugMode) {
                                  print(selectOption);
                                }
                              },
                            ),
                            const SizedBox(width: 20,),
                            RadioListTile(
                              title: const Text('Female'),
                              value: 'F',
                              groupValue: selectOption,
                              onChanged: (String? value){
                                cubit.changeGender(value!);
                                selectOption = cubit.gender!;
                                if (kDebugMode) {
                                  print(selectOption);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  age: ageController.text,
                                  sex: selectOption,
                                );
                              }
                            },
                            text: 'Register',
                            isUpperCase: true,
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

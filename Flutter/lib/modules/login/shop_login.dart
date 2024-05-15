import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:e_commerce_app/layout/full_app_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/layout/cubit.dart';
import 'package:e_commerce_app/modules/login/cubit.dart';
import 'package:e_commerce_app/modules/login/states.dart';
import 'package:e_commerce_app/modules/register/shop_register_screen.dart';
import 'package:e_commerce_app/shared/components/components.dart';
import 'package:e_commerce_app/shared/components/constants.dart';
import 'package:e_commerce_app/shared/network/local/cache_helper.dart';

// ignore: must_be_immutable
class ShopLoginScreen extends StatelessWidget {
   ShopLoginScreen({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context ) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit , ShopLoginStates>(
        listener: (context,state){
          if(state is ShopLoginSuccessState){
            if(state.loginModel.success!){
              CacheHelper.saveData(key: 'token', value: state.loginModel.userID).then((value) {
                token = state.loginModel.userID!;
                toast(
                  msg: 'Login Successfully',
                  state: ToastState.success,
                );
                ShopCubit.get(context).getUsersDefault();
                navigateToFinish(context, const FullView());
              });
              
                //print('Token is : ${state.loginModel.data?.token}');
            }
            else{
              toast(
                msg: 'error when logging',
                state: ToastState.error,
              );
                //print(state.loginModel.message);
            }
          }else if(state is ShopLoginErrorState){
            toast(
              msg: 'Connection Error',
              state: ToastState.error,
            );
          }
        },
        builder: (context , state) {
          return kIsWeb ?
          Row(
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
                    centerTitle: true,
                    title: Text(
                      'ShoeShake Admin',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                  body:  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOGIN',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Login now to browse our hot offers',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              defaultFormField(
                                onChange: (value){},
                                onTap: (value){},
                                onSubmit: (value){},
                                suffixPressed: (){},
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validate: (String value){
                                  if(value.isEmpty){
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
                                  onChange: (value){},
                                  onTap: (value){},
                                  controller: passwordController,
                                  type: TextInputType.visiblePassword,
                                  suffix: ShopLoginCubit.get(context).suffix,
                                  onSubmit: (value){
                                    if(formKey.currentState!.validate()){
                                      ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  isPassword: ShopLoginCubit.get(context).isPassword,
                                  suffixPressed: (){
                                    ShopLoginCubit.get(context).changePasswordVisibility();
                                  } ,
                                  validate: (String value){
                                    if(value.isEmpty){
                                      return 'password is too short';
                                    }
                                  },
                                  label: 'Password',
                                  prefix: Icons.lock_outline
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ConditionalBuilder(
                                condition: state is! ShopLoginLoadingState || state is ShopLoginErrorState,
                                builder: (context) => defaultButton(
                                  function: (){
                                    if(formKey.currentState!.validate()){
                                      ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                      ShopCubit.get(context).changeCurrentIndex(0 , context);
                                    }
                                  },
                                  text: 'login',
                                  isUpperCase: true,
                                ),
                                fallback: (context) => const Center(child: CircularProgressIndicator()),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don\'t have an Account?  '),
                                  TextButton(
                                    onPressed: (){
                                      navigateTo(context,  ShopRegisterScreen());
                                    },
                                    child: Text('register now'.toUpperCase()),
                                  ),
                                ],
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
          ) :
          Scaffold(
            appBar: AppBar(),
            body:  Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          onChange: (value){},
                          onTap: (value){},
                          onSubmit: (value){},
                          suffixPressed: (){},
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value){
                              if(value.isEmpty){
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
                            onChange: (value){},
                            onTap: (value){},
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: ShopLoginCubit.get(context).suffix,
                            onSubmit: (value){
                              if(formKey.currentState!.validate()){
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffixPressed: (){
                              ShopLoginCubit.get(context).changePasswordVisibility();
                            } ,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'password is too short';
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState || state is ShopLoginErrorState,
                            builder: (context) => defaultButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  ShopCubit.get(context).changeCurrentIndex(0 , context);
                                }
                              },
                              text: 'login',
                              isUpperCase: true,
                            ),
                            fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an Account?  '),
                            TextButton(
                              onPressed: (){
                                navigateTo(context,  ShopRegisterScreen());
                              },
                              child: Text('register now'.toUpperCase()),
                            ),
                          ],
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

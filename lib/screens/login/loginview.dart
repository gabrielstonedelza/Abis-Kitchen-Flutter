import 'dart:ui';
import 'package:abiskitchen/controllers/login/logincontroller.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import '../../global.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController loginController = Get.find();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final formKey = GlobalKey<FormState>();

  bool isPosting = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/food.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              const Center(
                child: Text("Abi's Kitchen",style: TextStyle(color: CupertinoColors.white,fontWeight: FontWeight.bold,fontSize: 25),),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16.0,sigmaY: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: CupertinoColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 1.5,
                              color: CupertinoColors.white.withOpacity(0.3)
                          )
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CupertinoFormRow(
                                  prefix: const Icon(CupertinoIcons.mail),
                                  child: CupertinoTextFormFieldRow(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return "Please enter your username";
                                      }
                                    },
                                    controller: _usernameController,
                                    cursorColor: CupertinoColors.white,
                                    autocorrect: true,
                                    keyboardType: TextInputType.text,
                                    toolbarOptions: const ToolbarOptions(
                                        copy: true,
                                        paste: true,
                                        cut: true
                                    ),
                                    style: const TextStyle(color: CupertinoColors.white),
                                    placeholder: "email is required",
                                  ),
                                ),
                                CupertinoFormRow(
                                  prefix: const Icon(CupertinoIcons.lock),
                                  child: CupertinoTextFormFieldRow(
                                    controller: _passwordController,
                                    // placeholder: "Enter your valid password",
                                    obscureText: true,
                                    cursorColor: CupertinoColors.white,
                                    autocorrect: true,
                                    keyboardType: TextInputType.text,
                                    toolbarOptions: const ToolbarOptions(
                                        copy: true,
                                        paste: true,
                                        cut: true
                                    ),
                                    style: const TextStyle(color: CupertinoColors.white),
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return "password is required";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              loginController.isLoggingIn ? const Center(
               child: CupertinoActivityIndicator(
                 animating: true,
                 radius: 20,
                 color: defaultColor
               )
             ) : CupertinoButton(
                  color: primaryColor,
                  child: const Text("Login",style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: (){
                    loginController.isLoggingIn = true;

                    if(!formKey.currentState!.validate()){
                      return;
                    }
                    else{
                      loginController.loginUser(_usernameController.text, _passwordController.text, context);
                    }

                  }
              ),
             !loginController.isUser ? Padding(
                padding: const EdgeInsets.only(top:18.0,bottom:18.0,),
                child: Center(
                  child: Text(loginController.errorMessage,style:const TextStyle(color:CupertinoColors.destructiveRed,fontWeight: FontWeight.bold)),
                ),
              ) : Container()
            ],
          ),
        )
    );
  }
}

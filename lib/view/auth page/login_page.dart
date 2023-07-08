import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shopy/model/language/language_constants.dart';
import 'package:shopy/provider/auth_provider.dart';
import 'package:shopy/services/user_service.dart';
import 'package:shopy/view/auth%20page/sign_up_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../model/users.dart';
import '../../provider/autoValidate_provider.dart';
import '../common widget/custom_button.dart';
import '../common widget/custom_text_field.dart';
import '../common widget/snackbar.dart';
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  final _form = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
        (bool isSupported) => setState((){
          _supportState = isSupported;
        })
    );
    getBiometricSetting();
  }

  Future<void> _getAvailableBiometric()async{
   List<BiometricType> availableBiometric = await auth.getAvailableBiometrics();
   print(availableBiometric);
   if(!mounted){
     return;
   }
  }

  //authenticate biometric login
  Future<void> _authenticate()async{
    try{
      bool authenticated = await auth.authenticate(localizedReason: 'Login to SHOPY',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false
        )
      );
      
      if(authenticated){
        final userAuth = ref.watch(authProvider);
        final storage = FlutterSecureStorage();

        String? storedValue = await storage.read(key: 'password');
        // print('Retrieved value: $storedValue');

        if(userAuth.user.isEmpty){
          SnackShow.showFailure(context, 'To enable biometric login you need to login first');
        }else{
          ref.watch(authProvider.notifier).userLogin(
              email: userAuth.user[0].email,
              password: '$storedValue'
          );
          // print(userAuth.user[0].email);
          // print(userAuth.user[0].password);
        }
      }

    }on PlatformException catch(e){
      print(e);
    }
  }

  //check biometric is enabled
  bool isBiometricEnabled = false; // Initialize with the default value

  void getBiometricSetting() async {
    var box = await Hive.openBox('biometric');
    bool biometricSetting = box.get('key', defaultValue: false);
    setState(() {
      isBiometricEnabled = biometricSetting;
    });
    box.close();
  }



  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        SnackShow.showSuccess(context, 'Login Successful');
        Hive.box('status').put('key', 'yes');
      }
    });

    final mode = ref.watch(autoValidateMode);
    final userLogin = ref.watch(authProvider);
    final allUsers = ref.watch(userProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.grey.shade800
        ),
      ),
      body:  Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Form(
              key: _form,
              autovalidateMode: mode,
              child: Column(
                children: [
                  Icon(Icons.lock, size: 150,),
                  CustomTextForm(
                    labelText: AppLocalizations.of(context)!.email,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (val){
                      if (val!.isEmpty) {
                        return translation(context).emailRequired;
                      } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)) {
                        return translation(context).validEmail;
                      }
                      return null;
                    },
                  ),
                  CustomTextForm(
                      labelText: AppLocalizations.of(context)!.password,
                      obscureText: obscureText,
                      onChanged: (val){setState(() {});},
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      suffixIcon: passwordController.text.isEmpty ? null : IconButton(
                        onPressed: (){setState(() {obscureText = !obscureText;});},
                        icon: obscureText ? Icon(Icons.visibility, color: Colors.white,) : Icon(Icons.visibility_off, color: Colors.white,),),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return translation(context).passwordRequired;
                        } else if (val.length <=5) {
                          return translation(context).passwordLength;
                        }
                        return null;
                      }
                  ),
                  SizedBox(height: 12.h,),
                  CustomButton(text: AppLocalizations.of(context)!.login,
                    onPressed:() {
                      _form.currentState!.save();
                      FocusScope.of(context).unfocus();
                      if(_form.currentState!.validate()){
                        ref.read(authProvider.notifier).userLogin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                        );
                      }else{
                        ref.read(autoValidateMode.notifier).autoValidate();
                      }
                    },),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(AppLocalizations.of(context)!.already),
                  ),
                  CustomButton(
                      onPressed: (){
                        Get.to(()=> SignUp(), transition: Transition.rightToLeft);
                      },
                      text: AppLocalizations.of(context)!.signup,),

                  SizedBox(height: 70.h,),
                 if(isBiometricEnabled) Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: Text(translation(context).biometricLogin, style: TextStyle(fontSize: 12.sp))),
                      IconButton(
                          onPressed: (){
                            _authenticate();
                          },
                          splashRadius: 50.0,
                          splashColor: Colors.green,
                          iconSize: 55.0,
                          color: Colors.green,
                          icon: Icon(Icons.fingerprint)),
                    ],
                  )

                  // ElevatedButton(
                  //     onPressed: (){
                  //       _getAvailableBiometric();
                  //     },
                  //     child: Text('available biometric'))
                ],
              ),
            ),
          ),

          //show loading
          userLogin.isLoad ?
              Center(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  height: 65.h,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      Text(translation(context).wait, style: TextStyle(color: Colors.black),),
                      SizedBox(height: 4.h,),
                      Transform.scale(
                          scale: 0.7,
                          child: CircularProgressIndicator(color: Colors.black,))
                    ],
                  ),
                ),
              )
              : Container(),
        ],
      ),
    );
  }
}

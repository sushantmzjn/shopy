import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopy/model/language/language_constants.dart';
import 'package:shopy/provider/auth_provider.dart';
import 'package:shopy/provider/autoValidate_provider.dart';
import 'package:shopy/view/common%20widget/custom_button.dart';
import 'package:shopy/view/common%20widget/custom_text_field.dart';

import '../common widget/snackbar.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _form = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        Navigator.of(context).pop();
        SnackShow.showSuccess(context, 'Sign up Successful');
      }
    });

    final mode = ref.watch(autoValidateMode);
    final userSignUp = ref.watch(authProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translation(context).signup),
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.grey.shade800
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: Form(
          key: _form,
          autovalidateMode: mode,
          child: Column(
            children: [
              Icon(Icons.lock, size: 150,),
              CustomTextForm(
                labelText: translation(context).fullName,
                keyboardType: TextInputType.text,
                obscureText: false,
                controller: nameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Name is required';
                    } else if (val.length <=5) {
                      return 'Name must be at least 6 character ';
                    }
                    return null;
                  }
              ),
              CustomTextForm(
                labelText: translation(context).email,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (val){
                  if (val!.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)) {
                    return 'Please provide a valid email';
                  }
                  return null;
                },
              ),
              CustomTextForm(
                labelText: translation(context).password,
                obscureText: obscureText,
                onChanged: (val){setState(() {});},
                keyboardType: TextInputType.text,
                controller: passwordController,
                  suffixIcon: passwordController.text.isEmpty ? null : IconButton(
                    onPressed: (){setState(() {obscureText = !obscureText;});},
                    icon: obscureText ? Icon(Icons.visibility, color: Colors.white,) : Icon(Icons.visibility_off, color: Colors.white,),),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Password is required';
                    } else if (val.length <=5) {
                      return 'password must be at least 6 character ';
                    }
                    return null;
                  }
              ),
              SizedBox(height: 12.h,),
              CustomButton(text: userSignUp.isLoad ? translation(context).wait :  translation(context).signup,
                onPressed: userSignUp.isLoad ? null : () {
                  _form.currentState!.save();
                  FocusScope.of(context).unfocus();
                  if(_form.currentState!.validate()){
                    ref.read(authProvider.notifier).userSignUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        full_name: nameController.text.trim()
                    );
                  }else{
                    ref.read(autoValidateMode.notifier).autoValidate();
                  }
                },),
            ],
          ),
        ),
      ),
    );
  }
}

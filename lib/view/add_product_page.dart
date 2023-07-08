import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopy/model/language/language_constants.dart';
import 'package:shopy/provider/auth_provider.dart';
import 'package:shopy/provider/autoValidate_provider.dart';
import 'package:shopy/services/product_service.dart';
import 'package:shopy/view/common%20widget/custom_button.dart';

import '../provider/product_provider.dart';
import 'common widget/custom_text_field.dart';
import 'common widget/snackbar.dart';
class CreateProduct extends ConsumerStatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends ConsumerState<CreateProduct> {
  final _form = GlobalKey<FormState>();
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen(productProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        ref.invalidate(getProduct);
        Navigator.of(context).pop();
        SnackShow.showSuccess(context, 'Product added successful');
      }
    });

    final image = ref.watch(imageProvider);
    final mode = ref.watch(autoValidateMode);
    final auth  = ref.watch(authProvider);
    final addProduct =  ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).addProduct,),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _form,
          autovalidateMode: mode,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    Get.defaultDialog(
                        title: 'Select',
                        content:Text('Choose from'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                            ref.read(imageProvider.notifier).pickImage(true);
                          }, child: const Text('Camera')),
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                            ref.read(imageProvider.notifier).pickImage(false);
                          }, child: const Text('Gallery')),
                        ]
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.white
                      )
                    ),
                    child: image == null ? Text(translation(context).imageSelect) : Image.file(File(image.path)),
                  ),
                ),
                CustomTextForm(
                  labelText: translation(context).productName,
                  keyboardType: TextInputType.text,
                  validator: (val){
                    if(val!.isEmpty){
                      return 'required';
                    }
                    return null;
                  },
                  controller: productController,
                  obscureText: false,
                ),
                CustomTextForm(
                  labelText: translation(context).productDetail,
                  keyboardType: TextInputType.text,
                  validator: (val){
                    if(val!.isEmpty){
                      return 'required';
                    }
                    return null;
                  },
                  controller: detailController,
                  obscureText: false,
                ),
                CustomTextForm(
                  labelText: translation(context).productPrice,
                  keyboardType: TextInputType.number,
                  validator: (val){
                    if(val!.isEmpty){
                      return 'required';
                    }
                    return null;
                  },
                  controller: priceController,
                  obscureText: false,
                ),
                SizedBox(height:12.h),
                CustomButton(onPressed: addProduct.isLoad ? null : (){
                  _form.currentState!.save();
                  FocusScope.of(context).unfocus();
                  if(_form.currentState!.validate()){
                    if(image == null){
                      SnackShow.showFailure(context, 'image required');
                    }else{
                     ref.read(productProvider.notifier).productCreate(
                          product_name: productController.text.trim(),
                          product_detail: detailController.text.trim(),
                          price:int.parse( priceController.text.trim()),
                          image: image,
                          token: auth.user[0].token
                      );
                    }

                  }else{
                    ref.read(autoValidateMode.notifier).autoValidate();
                  }
                }, text: addProduct.isLoad ? translation(context).wait :translation(context).submit,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

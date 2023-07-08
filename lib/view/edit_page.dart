import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopy/model/language/language_constants.dart';
import 'package:shopy/provider/auth_provider.dart';
import 'package:shopy/provider/product_provider.dart';
import 'package:shopy/view/common%20widget/custom_button.dart';
import 'package:shopy/view/common%20widget/custom_text_field.dart';

import '../model/product model/product.dart';
import '../provider/autoValidate_provider.dart';
import '../services/product_service.dart';
import 'common widget/snackbar.dart';

class EditPage extends ConsumerStatefulWidget {
  Product product;
  EditPage({required this.product});

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  final _form = GlobalKey<FormState>();
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productController.text = widget.product.product_name.toString();
    priceController.text = widget.product.price.toString();
    detailController.text = widget.product.product_detail.toString();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(productProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        ref.invalidate(getProduct);
        Navigator.of(context).pop();
        SnackShow.showSuccess(context, 'Product Updated Successfully');
      }
    });


    final image = ref.watch(imageProvider);
    final productUpdate = ref.watch(productProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).update),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
        child: Form(
          key: _form,
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
                  width: MediaQuery.of(context).size.width,
                  height: 150.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white)
                  ),
                  child: image == null ?  Image.network(widget.product.image) : Image.file(File(image.path)),
                ),
              ),
              SizedBox(height: 16.h,),
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
                  obscureText: false),
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
                  obscureText: false),
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
                  obscureText: false),
              SizedBox(height: 20.h,),
              CustomButton(onPressed: productUpdate.isLoad ? null : (){
                _form.currentState!.save();
                FocusScope.of(context).unfocus();
                if(_form.currentState!.validate()){
                  if(image == null){
                    ref.read(productProvider.notifier).updateProduct(
                      product_name: productController.text.trim(),
                      product_detail: detailController.text.trim(),
                      price: int.parse(priceController.text.trim()),
                      productId: widget.product.id,
                      token: auth.user[0].token,
                    );

                  }else{
                    ref.read(productProvider.notifier).updateProduct(
                        product_name: productController.text.trim(),
                        product_detail: detailController.text.trim(),
                        price: int.parse(priceController.text.trim()),
                        productId: widget.product.id,
                        token: auth.user[0].token,
                        image: image,
                        public_id: widget.product.public_id
                    );
                  }

                }
              }, text: productUpdate.isLoad ? translation(context).wait  : translation(context).update)
            ],
          ),
        ),
      ),
    );
  }
}

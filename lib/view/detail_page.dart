import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopy/model/product%20model/product.dart';
import 'package:shopy/provider/auth_provider.dart';
import 'package:shopy/provider/product_provider.dart';
import 'package:shopy/services/product_service.dart';
import 'package:shopy/view/common%20widget/custom_button.dart';
import 'package:shopy/view/edit_page.dart';
import 'common widget/snackbar.dart';
import 'package:shopy/model/language/language_constants.dart';


class DetailPage extends ConsumerStatefulWidget {
  final Product product;
  DetailPage({required this.product});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(productProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        ref.invalidate(getProduct);
        Navigator.of(context).pop();
        SnackShow.showSuccess(context, 'Product Deleted Successfully');
      }
    });

    
    final deleteProduct = ref.watch(productProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).productDetail),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: 180.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black)
                  ),
                  child: Hero(
                      tag: 'image-${widget.product.id}',
                      child: Image.network(widget.product.image,)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.product.product_name),
                      Text('Rs. ${widget.product.price}'),
                    ],
                  ),
                ),
                Text(widget.product.product_detail),
              ],
            ),
            Column(
              children: [
                CustomButton(onPressed: (){
                  Get.to(()=> EditPage(product: widget.product), transition: Transition.leftToRightWithFade);
                }, text: translation(context).update),
                CustomButton(onPressed: ()async{
                  await showDialog(
                      context: context,
                      builder: (BuildContext builder){
                        return StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) setState) {
                            return AlertDialog(
                              title: Text('Are you sure?'),
                              actions: [
                                TextButton(onPressed: (){
                                  ref.read(productProvider.notifier).deleteProduct(
                                      productId: widget.product.id,
                                      publicId: widget.product.public_id,
                                      token: auth.user[0].token);
                                  Navigator.pop(context);
                                }, child: Text('Yes')),
                                TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                }, child: Text('No')),
                              ],);
                            },);
                      });




                }, text: translation(context).delete),
              ],
            )
          ],
        ),
      ),
    );
  }
}

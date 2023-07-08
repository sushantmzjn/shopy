
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopy/model/product%20model/product_state.dart';

import '../services/product_service.dart';

final productProvider =StateNotifierProvider<ProductProvider, ProductState>((ref) => ProductProvider(
    ProductState(errMessage: '', isError: false, isLoad: false, isSuccess: false)
));

class ProductProvider extends StateNotifier<ProductState>{
  ProductProvider(super.state);

  //create products
  Future<void> productCreate({
    required String product_name,
    required String product_detail,
    required int price,
    required XFile image,
    required String token
  })async{
    state = state.copyWith(isLoad: true,isError: false,isSuccess: false);
    final response = await ProductService.productCreate(
        product_name: product_name,
        product_detail: product_detail,
        price: price,
        image: image,
        token: token
    );
    response.fold(
            (l) => state = state.copyWith(isLoad: false,isError: true,isSuccess: false, errMessage: l),

            (r) => state = state.copyWith(isLoad: false,isError: false,isSuccess: r, errMessage: '')
    );
  }

  //delete
  Future<void> deleteProduct({
    required String productId,
    required String publicId,
    required String token
  })async{
    state = state.copyWith(isLoad: true,isError: false,isSuccess: false);
    final response = await ProductService.deleteProduct(
        productId: productId,
        publicId: publicId,
        token: token);
    response.fold(
            (l) => state = state.copyWith(isLoad: false,isError: true,isSuccess: false, errMessage: l),

            (r) => state = state.copyWith(isLoad: false,isError: false,isSuccess: true, errMessage: '')
    );
  }

  //update product
  Future<void>  updateProduct({
    required String product_name,
    required String product_detail,
    required int price,
    required String productId,
    XFile? image,
    String? public_id,
    required String token
  }) async{
    state = state.copyWith(isLoad: true,isError: false,isSuccess: false);
    final response  = await ProductService.updateProduct(
        product_name: product_name,
        product_detail: product_detail,
        price: price,
        productId: productId,
        token: token,
        image: image,
        public_id: public_id
    );
    response.fold(
            (l) => state = state.copyWith(isLoad: false,isError: true,isSuccess: false, errMessage: l),
            (r) => state = state.copyWith(isLoad: false,isError: false,isSuccess: true, errMessage: '')
    );
  }

}
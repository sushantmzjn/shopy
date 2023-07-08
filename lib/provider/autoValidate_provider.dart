
//auto validate provider
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final autoValidateMode = StateNotifierProvider<AutoValidate, AutovalidateMode>((ref) => AutoValidate(AutovalidateMode.disabled));

class AutoValidate extends StateNotifier<AutovalidateMode>{
  AutoValidate(super.state);

  void autoValidate(){
    state = AutovalidateMode.onUserInteraction;
  }
}


final imageProvider = StateNotifierProvider.autoDispose<ImageProvider,XFile?>((ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?>{
  ImageProvider(super.state);

  void pickImage(bool isCamera)async{
    final ImagePicker picker = ImagePicker();
    if(isCamera){
      state = await picker.pickImage(source: ImageSource.camera);
    }else{
      state = await picker.pickImage(source: ImageSource.gallery);
    }
  }
}
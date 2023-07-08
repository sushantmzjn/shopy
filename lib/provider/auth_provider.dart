

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shopy/main.dart';
import 'package:shopy/model/user_state.dart';
import 'package:shopy/view/auth%20page/login_page.dart';
import 'package:shopy/view/dashboard_page.dart';

import '../model/user model/user.dart';
import '../services/auth_service.dart';



final authProvider = StateNotifierProvider<AuthProvider, UserState>((ref) => AuthProvider(
    UserState(
      errMessage: '',
      isError: false,
      isLoad: false,
      isSuccess: false,
      user: ref.watch(box),
    )
));


class AuthProvider extends StateNotifier<UserState>{
  AuthProvider(super.state);

  //user signup
  Future<void> userSignUp({
    required String email,
    required String password,
    required String full_name
  })async{
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final response = await AuthService.userSignUp(email: email, password: password, full_name: full_name);
    response.fold(
            (l){
          state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l);

        },
            (r) {
          state = state.copyWith(isLoad: false, isError: false, isSuccess: r, errMessage: '');
        }
    );

  }

  //user login
  Future<void> userLogin({
    required String email,
    required String password,
  })async{
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final response = await AuthService.userLogin(email: email, password: password,);
    response.fold(
            (l){
          state = state.copyWith(isLoad: false, isError: true, isSuccess: false, errMessage: l, user: []);
        },
            (r) {
          state = state.copyWith(isLoad: false, isError: false, isSuccess: true, errMessage: '', user: [r]);
        }
    );
  }

  //user logout
  void  userLogOut() async{
    // final box =  Hive.box<User>('user');
    // box.clear();
    // state = state.copyWith(user: []);
    Get.off(()=> LoginPage());
  }




}
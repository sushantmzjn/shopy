import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shopy/api.dart';
import 'package:shopy/model/user%20model/user.dart';
import 'package:shopy/view/dashboard_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api_exception.dart';

class AuthService {
  static Dio dio = Dio();

  //user signup
  static Future<Either<String, bool>> userSignUp({
    required String email,
    required String password,
    required String full_name
  })async{
    try{
      final response = await dio.post(Api.userSignUp, data: {
        'email' : email,
        'password' : password,
        'full_name': full_name

      });
      return const Right(true);
    } on DioError catch(err){
      return Left(DioException.getDioError(err));

    }
  }

  //user login
  static Future<Either<String, User>> userLogin({
    required String email,
    required String password,
  })async{
    try{
      final response = await dio.post(Api.userLogin, data: {
        'email' : email,
        'password' : password,
      });
      final user = User.fromJson(response.data);
      //secure flutter storage
      final storage = FlutterSecureStorage();
      await storage.deleteAll();
      await storage.write(key: 'password', value: password);


      final box =  Hive.box<User>('user');
      box.clear();
      final user1 = User(
          id: user.id,
          email: user.email,
          token: user.token,
          username: user.username,
      );
      Hive.box<User>('user').add(user1);
      return Right(user);
    } on DioError catch(err){
      return Left(DioException.getDioError(err));

    }
  }


}

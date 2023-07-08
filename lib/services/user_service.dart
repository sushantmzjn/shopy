
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopy/api.dart';
import 'package:shopy/model/users.dart';

import '../api_exception.dart';

final userProvider = FutureProvider((ref) => UserService.getAllUsers());

class UserService{
  static Dio dio = Dio();

  //get all users
static Future<List<GetUser>> getAllUsers()async{
  try{
    final res = await dio.get(Api.getUsers);
    final data = (res.data as List).map((e) => GetUser.fromJson(e)).toList();

    return data;

  }on DioError catch(err){
    print(err);
    throw DioException.getDioError(err);

  }
}
}
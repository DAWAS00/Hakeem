import 'package:dio/dio.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  Future<UserModel> login(LoginRequestModel request);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserModel> login(LoginRequestModel request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}

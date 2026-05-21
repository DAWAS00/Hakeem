import 'package:dio/dio.dart';
import '../../domain/entities/signup_form_data.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';

abstract interface class SignupRemoteDatasource {
  Future<UserModel> register(SignupFormData data);
}

class SignupRemoteDatasourceImpl implements SignupRemoteDatasource {
  const SignupRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserModel> register(SignupFormData data) async {
    final response = await _dio.post(
      '/auth/register',
      data: SignupRequestModel(data).toJson(),
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}

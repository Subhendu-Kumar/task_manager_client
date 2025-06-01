import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager_client/models/user_model.dart';
import 'package:task_manager_client/core/constants/constants.dart';
import 'package:task_manager_client/core/services/sp_service.dart';
import 'package:task_manager_client/features/auth/repository/auth_local_repository.dart';

class AuthRemoteRepository {
  final spService = SpService();
  final authLocalRepository = AuthLocalRepository();

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['detail'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/auth/token/verify'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }
      final userResponse = await http.get(
        Uri.parse('${ServerConstant.serverURL}/auth/user'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      if (userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['detail'];
      }
      return UserModel.fromJson(userResponse.body);
    } catch (e) {
      final user = await authLocalRepository.getUser();
      return user;
    }
  }
}

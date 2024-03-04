import 'dart:developer';
import 'dart:io';

import 'package:barber_shop/src/core/exceptions/auth_exception.dart';
import 'package:barber_shop/src/core/exceptions/repository_exception.dart';
import 'package:barber_shop/src/core/fp/either.dart';
import 'package:barber_shop/src/core/rest_client/rest_client.dart';
import 'package:barber_shop/src/models/user_model.dart';
import 'package:barber_shop/src/repositories/user/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;
  UserRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');
      return Success(UserModel.fromJson(data));
    } on DioException catch (e, s) {
      log("Erro ao buscar usuário", stackTrace: s);
      return Failure(
          RepositoryException(message: e.message ?? "Erro ao buscar usuário"));
    } on ArgumentError catch (e, s) {
      log("Invalid json", stackTrace: s);
      return Failure(RepositoryException(message: e.message));
    }
  }

  @override
  Future<Either<AuthException, String>> login(
      String email, String password) async {
    try {
      final Response(:data) = await restClient.unAuth.post(
        '/auth',
        data: {
          "email": email,
          "password": password,
        },
      );

      return Success(data["access_token"]);
    } on DioException catch (e, s) {
      if (e.response != null) {
        final Response(:statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log("Login ou senha inválidos", stackTrace: s);
          return Failure(AuthUnathorizedException());
        }
      }
      log("Error ao realizar login", stackTrace: s);
      return Failure(
        AuthError(message: e.message ?? "Error ao realizar login"),
      );
    }
  }
}
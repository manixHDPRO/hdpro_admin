import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hdpro_admin/core/constants/api_endpoints.dart';
import 'package:hdpro_admin/core/errors/exceptions.dart';
import 'package:hdpro_admin/core/network/api_client.dart';
import 'package:hdpro_admin/features/auth/data/models/auth_tokens_model.dart';
import 'package:hdpro_admin/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String? phoneNumber,
    String? fullName,
  );

  Future<Map<String, dynamic>> login(String email, String password);
  Future<UserModel> getUserProfile();

  Future<UserModel> updateUserProfile(
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Uint8List? profileImageBytes,
  );

  Future<AuthTokensModel> refreshTokens();
  Future<bool> validateToken();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final responseData = await apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (responseData['success'] != true) {
        throw ServerException(
          message: responseData['error'] ?? 'La connexion a échoué',
        );
      }

      final data = responseData['data'];
      return data;
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Délai de connexion dépassé. Veuillez vérifier votre connexion Internet.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Le serveur met trop de temps à répondre. Veuillez réessayer plus tard.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Erreur de connexion. Veuillez vérifier votre connexion internet.';
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;
      // Handle specific error responses
      if (data is Map && data.containsKey('error')) {
        final errorMessage = data['error'].toString();
        // check for specific error patterns
        if (errorMessage.contains('locked')) {
          return "Votre compte a été temporairement bloqué suite à plusieurs tentatives de connexion infructueuses. Veuillez réessayer plus tard.";
        } else if (errorMessage.contains(
          'Adresse e-mail ou mot de passe invalide',
        )) {
          return "L'adresse e-mail ou le mot de passe que vous avez saisi est incorrect. Veuillez réessayer.";
        } else if (errorMessage.contains('disabled')) {
          return "Votre compte a été désactivé. Veuillez contacter l'assistance pour obtenir de l'aide.";
        }
        return errorMessage;
      } else if (statusCode == 401) {
        return "Adresse e-mail ou mot de passe incorrects. Veuillez vérifier vos identifiants et réessayer.";
      } else if (statusCode == 403) {
        if (data is Map &&
            data.containsKey('lockout') &&
            data['lockout'] == true) {
          return "Compte temporairement bloqué suite à plusieurs tentatives infructueuses. Veuillez réessayer plus tard.";
        }

        return "Accès refusé. Veuillez contacter l'assistance si le problème persiste.";
      } else if (statusCode == 404) {
        return "Service introuvable. Veuillez vérifier votre connexion et réessayer.";
      } else if (statusCode == 400) {
        return "Requête invalide. Veuillez vérifier vos saisies et réessayer.";
      } else if (statusCode == 500) {
        return "Erreur serveur. Veuillez réessayer plus tard ou contacter l'assistance.";
      } else {
        return "Erreur serveur ($statusCode). Veuillez réessayer plus tard.";
      }
    }
    return "Erreur réseau. Veuillez vérifier votre connexion et réessayer.";
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthTokensModel> refreshTokens() {
    // TODO: implement refreshTokens
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String? phoneNumber,
    String? fullName,
  ) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUserProfile(
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Uint8List? profileImageBytes,
  ) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }

  @override
  Future<bool> validateToken() {
    // TODO: implement validateToken
    throw UnimplementedError();
  }
}

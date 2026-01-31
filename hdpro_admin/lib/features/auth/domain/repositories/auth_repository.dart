import 'package:dartz/dartz.dart';
import 'package:hdpro_admin/core/errors/failures.dart';
import 'package:hdpro_admin/features/auth/domain/entities/auth_credentials.dart';
import 'package:hdpro_admin/features/auth/domain/entities/auth_tokens.dart';
import 'package:hdpro_admin/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Créer un nouvel utilisateur avec un e-mail et un mot de passe
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword(
    AuthCredentials credentials,
  );

  /// Se connecter avec un e-mail et un mot de passe
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword(
    AuthCredentials credentials,
  );

  /// Actualiser les jetons(tokens) d'authentification
  Future<Either<Failure, AuthTokens>> refreshTokens();

  /// Vérifier si le jeton(token) actuel est toujours valide
  Future<Either<Failure, bool>> validateToken();

  /// Obtenir l’utilisateur actuellement authentifié
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Mettre à jour les informations du profil utilisateur
  Future<Either<Failure, UserEntity>> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    dynamic profileImage,
  });

  /// Déconnecter l'utilisateur actuel
  Future<Either<Failure, void>> logout();
}

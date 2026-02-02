import 'package:dartz/dartz.dart';
import 'package:hdpro_admin/core/errors/failures.dart';
import 'package:hdpro_admin/core/usecases/usecase.dart';
import 'package:hdpro_admin/features/auth/domain/entities/auth_tokens.dart';
import 'package:hdpro_admin/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUseCase implements UseCase<AuthTokens, NoParams> {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);
  @override
  Future<Either<Failure, AuthTokens>> call(NoParams params) {
    return repository.refreshTokens();
  }
}

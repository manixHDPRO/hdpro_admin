import 'package:dartz/dartz.dart';
import 'package:hdpro_admin/core/errors/failures.dart';
import 'package:hdpro_admin/core/usecases/usecase.dart';
import 'package:hdpro_admin/features/auth/domain/repositories/auth_repository.dart';

class ValidateTokenUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.validateToken();
  }
}

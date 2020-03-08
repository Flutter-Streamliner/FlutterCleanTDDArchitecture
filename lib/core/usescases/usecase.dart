import 'package:dartz/dartz.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
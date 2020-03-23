import 'package:dartz/dartz.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final int number = int.parse(str);
      if (number < 0) throw FormatException();
      return Right(number);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  
  @override
  List<Object> get props => [];

}
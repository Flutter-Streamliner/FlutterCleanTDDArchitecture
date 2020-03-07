import 'package:dartz/dartz.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  
  Future<Either<Failure, NumberTrivia>> getConcreteTriviaNumber(int number);
  Future<Either<Failure, NumberTrivia>> getRandomTriviaNumber();

}
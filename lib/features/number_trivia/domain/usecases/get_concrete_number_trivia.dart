import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetContreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetContreteNumberTrivia({this.repository});

  Future<Either<Failure, NumberTrivia>> execute({@required int number}) async {
    return await repository.getConcreteTriviaNumber(number);
  }
}
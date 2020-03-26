import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/core/usescases/usecase.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetContreteNumberTrivia implements UseCase <NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetContreteNumberTrivia({@required this.repository});

  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteTriviaNumber(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];

  
}
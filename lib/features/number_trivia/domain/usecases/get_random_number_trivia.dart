import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/core/usescases/usecase.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({@required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) {
    return repository.getRandomTriviaNumber();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];

}
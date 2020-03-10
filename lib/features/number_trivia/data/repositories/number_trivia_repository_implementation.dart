import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/core/platform/network_info.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImplementation extends NumberTriviaRepository {

  final NumberTriviaRemoteDatasource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImplementation({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteTriviaNumber(int number) {
    return null;
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomTriviaNumber() {
    return null;
  }

}
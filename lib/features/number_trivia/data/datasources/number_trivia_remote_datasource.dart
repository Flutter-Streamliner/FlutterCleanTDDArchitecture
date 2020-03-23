import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:simple_ttd_architecture/core/error/exceptions.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// Calls the http://numberapi.com/{number} endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numberapi.com/random endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImplementation implements NumberTriviaRemoteDatasource {
  final Client client;

  NumberTriviaRemoteDatasourceImplementation({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final result = await client.get(url, headers: {'Content-Type' : 'application/json',});
    if (result.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(result.body));
    } else {
      throw ServerException();
    }
  }

}
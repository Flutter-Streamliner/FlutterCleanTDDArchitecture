import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;
import 'package:simple_ttd_architecture/core/error/exceptions.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDatasourceImplementation remoteDatasource;
  MockHttpClient mockHttpClient;

  setUp((){
    mockHttpClient = MockHttpClient();
    remoteDatasource = NumberTriviaRemoteDatasourceImplementation(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))) 
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))) 
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
  
        // act
        remoteDatasource.getConcreteNumberTrivia(testNumber);
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$testNumber',
           headers: {'Content-Type' : "application/json"},
        )); 
      }
    );
    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
          // act
          final result = await remoteDatasource.getConcreteNumberTrivia(testNumber);
          // assert 
          expect(result, equals(testNumberTriviaModel));
      }
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDatasource.getConcreteNumberTrivia;
        // assert
        expect(() => call(testNumber), throwsA(isInstanceOf<ServerException>()));
      }
    );
  });

  group('getRandomNumberTrivia', (){
    final testNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should perform a GET request on a URL with random being endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteDatasource.getRandomNumberTrivia();
        // assert
        verify(
          mockHttpClient.get(
           'http://numbersapi.com/random',
            headers: {'Content-Type' : "application/json"},
          )
        );
      }
    );
    test(
      'should return a NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await remoteDatasource.getRandomNumberTrivia();
        // assert
        expect(result, equals(testNumberTriviaModel));

      }
    );
    test(
      'should return a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDatasource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      }
    );
  });
}
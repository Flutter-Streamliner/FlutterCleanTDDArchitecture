import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ttd_architecture/core/error/exceptions.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

 class MockSharedPreferences extends Mock implements SharedPreferences {  }

 void main() {
   MockSharedPreferences mockSharedPreferences;
   NumberTriviaLocalDataSourceImplementation numberTriviaLocalDataSourceImpl;

   setUp((){
     mockSharedPreferences = MockSharedPreferences();
     numberTriviaLocalDataSourceImpl = 
           NumberTriviaLocalDataSourceImplementation(sharedPreferences: mockSharedPreferences);
   });

   group('getLastNumberTrivia', (){
     final testNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
     test(
       'should return NumberTrivia from SharedPreferences when there is one in the cache ',
       () async {
         // arrange
         when(mockSharedPreferences.getString(any))
         .thenReturn(fixture('trivia_cached.json'));

         // act
         final result = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();

         // assert
         verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA ));
         expect(result, equals(testNumberTriviaModel));
       }
     );
     test(
       'should throw a CacheException  when there is not a cached value  ',
       () async {  
         // arrange
         when(mockSharedPreferences.getString(any))
         .thenReturn(null);

         // act
         final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;

         // assert
         expect(() => call(), throwsA(isInstanceOf<CacheException> ()));
       }
     );
   });

   group('cacheNumberTrivia', () {
     final testNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
     test(
       'should cache SharedPreferences to cache the data',
       () async {
         // arrange

         // act
         await numberTriviaLocalDataSourceImpl.cacheNumberTrivia(testNumberTriviaModel);
         // assert 
         final encodedJsonString = json.encode(testNumberTriviaModel.toJson());
         verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, encodedJsonString ));
       }
     );
   });
 } 
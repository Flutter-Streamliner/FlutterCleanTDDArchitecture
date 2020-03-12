import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ttd_architecture/core/error/exceptions.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  /// 
  /// Throws [CachedException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Calls the http://numberapi.com/random endpoint.
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImplementation implements NumberTriviaLocalDataSource {

  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImplementation({@required this.sharedPreferences});  

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final jsonString = json.encode(triviaToCache.toJson());
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    throw CacheException(); 
  }

} 
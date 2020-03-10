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
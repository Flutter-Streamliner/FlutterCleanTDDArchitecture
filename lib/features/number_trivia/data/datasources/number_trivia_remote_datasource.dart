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
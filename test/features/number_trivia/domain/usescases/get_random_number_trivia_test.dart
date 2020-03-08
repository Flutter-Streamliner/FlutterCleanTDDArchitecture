import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  final testNumberTrivia = NumberTrivia(number: 4, text: 'test');

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  test(
    'should get random trivia from the repository', 
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomTriviaNumber()).thenAnswer((_) async =>  Right(testNumberTrivia));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, Right(testNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomTriviaNumber());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

}
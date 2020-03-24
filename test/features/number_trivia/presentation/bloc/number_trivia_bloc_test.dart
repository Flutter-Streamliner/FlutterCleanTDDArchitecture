import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/core/util/input_converter.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetContreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main () {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  
  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getContreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter);
  });

  test(
    'initialState should be Empty',
    () {
      // assert
      expect(bloc.initialState, equals(Empty()));
    }
  );

  group('GetTriviaForConcreteNumber', () {
    final testNumberString = '1';
    final testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(testNumberParsed));
          // act
          bloc.add(GetTriviaForConcreteNumber(testNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          // assert
          verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
        }
      );
      test(
        'should emit [Error] when the input is invalid',
        () async* {
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
          // assert later
          expectLater(
            bloc.state, 
            emitsInAnyOrder([
              Empty(),
              Error(message: INVALID_INPUT_FAILURE_MESSAGE),
              ])
          );
          // act
          bloc.add(GetTriviaForConcreteNumber(testNumberString));
          
        }
      );
  });

}
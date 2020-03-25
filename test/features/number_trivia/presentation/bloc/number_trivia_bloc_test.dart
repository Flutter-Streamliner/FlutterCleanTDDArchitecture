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

  group('GetRandomTrivia', (){
    final testNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    test(
      'should get data from a random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
        // act
        bloc.add(GetTriviaRandomEvent());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      }
    );
    test(
      'should emit [Loading, Loaded] when data gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
        // expect later
        final expected = [Empty(), Loading(), Loaded(trivia: testNumberTrivia)];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaRandomEvent());
      }
    );
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));
      // expect later
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(GetTriviaRandomEvent());
    });
    test('should emit [Loading, Error] with a proper message for the error when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));
      // expect later
      final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      // act 
      bloc.add(GetTriviaRandomEvent());
    });
  });

  group('GetTriviaForConcreteNumber', () {
    final testNumberString = '1';
    final testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(testNumberParsed));
    }

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          // act
          bloc.add(GetTriviaForConcreteNumberEvent(testNumberString));
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
          bloc.add(GetTriviaForConcreteNumberEvent(testNumberString));
          
        }
      );
      test(
        'should get data from a concrete use case',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(testNumberTrivia));
          // act
          bloc.add(GetTriviaForConcreteNumberEvent(testNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));
          // assert
          verify(mockGetConcreteNumberTrivia(Params(number: testNumberParsed)));
        }
      );
      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(testNumberTrivia));
          // assert later
          final expected = [Empty(), Loading(), Loaded(trivia: testNumberTrivia)];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForConcreteNumberEvent(testNumberString));
        }
      );
      test(
        'should emit [Loading, Error] when getting data fails',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForConcreteNumberEvent(testNumberString));
        }
      );
      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
          // act
          bloc.add(GetTriviaForConcreteNumberEvent(testNumberString));
        }
      );
  });

}
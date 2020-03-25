import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/core/util/input_converter.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number should be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {

  final GetContreteNumberTrivia getContreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required this.getContreteNumberTrivia, 
    @required this.getRandomNumberTrivia, 
    @required this.inputConverter
  }) : assert (getContreteNumberTrivia != null),
       assert (getRandomNumberTrivia != null),
       assert (inputConverter != null);

  


  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaRandomEvent) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (numberTrivia) => Loaded(trivia: numberTrivia));
    }
    else if (event is GetTriviaForConcreteNumberEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
      // if success run right side if fail run code in left side
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        }, (integer) async* {
          yield Loading();
          final failureOrTrivia = await getContreteNumberTrivia(Params(number: integer));
          yield failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)), 
            (numberTrivia) => Loaded(trivia: numberTrivia),
          );
        });
    } 
  }

  String _mapFailureToMessage(Failure failure) {
    switch(failure.runtimeType) {
      case ServerFailure : return SERVER_FAILURE_MESSAGE;
      case CacheFailure : return CACHE_FAILURE_MESSAGE;
      default: return 'Unexpected Error';
    }
  }

}

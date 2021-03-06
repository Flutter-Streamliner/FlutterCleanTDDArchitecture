import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ttd_architecture/core/error/exceptions.dart';
import 'package:simple_ttd_architecture/core/error/failures.dart';
import 'package:simple_ttd_architecture/core/network/network_info.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDatasource {}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImplementation repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;

  setUp((){
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImplementation(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group(
    'getConcreteNumberTrivia', (){
      final testNumber = 1;
      final testNumberTriviaModel = NumberTriviaModel(number: testNumber, text: 'test trivia');
      final NumberTrivia testNumberTrivia = testNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          // arrange
          when(networkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repository.getConcreteTriviaNumber(testNumber);
          // assert 
          verify(networkInfo.isConnected);
        }
      );

      group('device is online',() {
        setUp((){
          when(networkInfo.isConnected).thenAnswer((_) async => true);
        });
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            // arrange
            when(remoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => testNumberTriviaModel);
            // act
            final result = await repository.getConcreteTriviaNumber(testNumber);
            // assert
            verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
            expect(result, Right(testNumberTrivia));
          }
        );
        test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
            // arrange
            when(remoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => testNumberTriviaModel);
            // act
            await repository.getConcreteTriviaNumber(testNumber);
            // assert
            verify(remoteDataSource.getConcreteNumberTrivia(testNumber)); 
            verify(localDataSource.cacheNumberTrivia(testNumberTriviaModel));
          }
        );
        test(
          'should return server failure when the call to remote data source is unsuccessful”',
          () async {
            // arrange
            when(remoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());
            // act
            final result = await repository.getConcreteTriviaNumber(testNumber);
            // assert
            verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
            verifyZeroInteractions(localDataSource); 
            expect(result, Left(ServerFailure()));
            
          }
        );
      });
      group('device is offline',() {
        setUp((){
          when(networkInfo.isConnected).thenAnswer((_) async => false);
        });
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            // arrange  
            when(localDataSource.getLastNumberTrivia()).thenAnswer((_) async => testNumberTriviaModel);
            // act
            final result = await repository.getConcreteTriviaNumber(testNumber);
            // assert
            expect(result, Right(testNumberTrivia));
            verify(localDataSource.getLastNumberTrivia());
            verifyZeroInteractions(remoteDataSource);
          }
        );
        test(
          'should return cache failure when there is no cached data present',
          () async {
            // arrange
            when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
            // act
            final result = await repository.getConcreteTriviaNumber(testNumber);
            // assert
            expect(result, Left(CacheFailure()));
            verify(localDataSource.getLastNumberTrivia());
            verifyZeroInteractions(remoteDataSource);
          }
        );
      });
    });

    group(
    'getRandomNumberTrivia', (){
      final testNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
      final NumberTrivia testNumberTrivia = testNumberTriviaModel;
      test(
        'should check if the device is online',
        () async {
          // arrange
          when(networkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repository.getRandomTriviaNumber();
          // assert 
          verify(networkInfo.isConnected);
        }
      );

      group('device is online',() {
        setUp((){
          when(networkInfo.isConnected).thenAnswer((_) async => true);
        });
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            // arrange
            when(remoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => testNumberTriviaModel);
            // act
            final result = await repository.getRandomTriviaNumber();
            // assert
            verify(remoteDataSource.getRandomNumberTrivia());
            expect(result, Right(testNumberTrivia));
          }
        );
        test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
            // arrange
            when(remoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => testNumberTriviaModel);
            // act
            await repository.getRandomTriviaNumber();
            // assert
            verify(remoteDataSource.getRandomNumberTrivia()); 
            verify(localDataSource.cacheNumberTrivia(testNumberTriviaModel));
          }
        );
        test(
          'should return server failure when the call to remote data source is unsuccessful”',
          () async {
            // arrange
            when(remoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
            // act
            final result = await repository.getRandomTriviaNumber();
            // assert
            verify(remoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(localDataSource); 
            expect(result, Left(ServerFailure()));
            
          }
        );
      });
      group('device is offline',() {
        setUp((){
          when(networkInfo.isConnected).thenAnswer((_) async => false);
        });
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            // arrange  
            when(localDataSource.getLastNumberTrivia()).thenAnswer((_) async => testNumberTriviaModel);
            // act
            final result = await repository.getRandomTriviaNumber();
            // assert
            expect(result, Right(testNumberTrivia));
            verify(localDataSource.getLastNumberTrivia());
            verifyZeroInteractions(remoteDataSource);
          }
        );
        test(
          'should return cache failure when there is no cached data present',
          () async {
            // arrange
            when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
            // act
            final result = await repository.getRandomTriviaNumber();
            // assert
            expect(result, Left(CacheFailure()));
            verify(localDataSource.getLastNumberTrivia());
            verifyZeroInteractions(remoteDataSource);
          }
        );
      });
    });
}
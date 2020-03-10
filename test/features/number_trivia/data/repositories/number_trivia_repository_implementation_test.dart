import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ttd_architecture/core/platform/network_info.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';

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
}
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ttd_architecture/core/network/network_info.dart';
import 'package:simple_ttd_architecture/core/util/input_converter.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:simple_ttd_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:simple_ttd_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  serviceLocator.registerFactory(() => NumberTriviaBloc(
    getContreteNumberTrivia: serviceLocator(),
    getRandomNumberTrivia: serviceLocator(),
    inputConverter: serviceLocator(),
  ));
  // Use case
  serviceLocator.registerLazySingleton(() => GetContreteNumberTrivia(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(repository: serviceLocator()));
  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() => 
    NumberTriviaRepositoryImplementation(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    )
  );
  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDatasource>(() => 
    NumberTriviaRemoteDatasourceImplementation(
      client: serviceLocator(),
    )
  );
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(() =>
    NumberTriviaLocalDataSourceImplementation(
      sharedPreferences: serviceLocator(),
    )
  );
  //! Core 
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(
    dataConnectionChecker: serviceLocator(),
  ));
  //! External 
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}

void initFeatures() {

}
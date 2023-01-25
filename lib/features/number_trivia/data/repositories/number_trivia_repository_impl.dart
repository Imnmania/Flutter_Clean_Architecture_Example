import '../../../../core/platform/network_info.dart';
import '../data_sources/number_trivia_local_data_source.dart';
import '../data_sources/number_trivia_remote_data_source.dart';

import '../../domain/entitites/number_trivia.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failures, NumberTrivia>?> getConcreteNumberTrivia(
      int number) async {
    networkInfo.isConnected;
    return Right(await remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failures, NumberTrivia>?> getRandomNumberTrivia() async {
    networkInfo.isConnected;
    return Right(await remoteDataSource.getRandomNumberTrivia());
  }
}

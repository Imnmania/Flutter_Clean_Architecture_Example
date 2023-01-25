import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(
    () {
      mockRemoteDataSource = MockRemoteDataSource();
      mockLocalDataSource = MockLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    },
  );

  group(
    'getConcreteNumberTrivia',
    () {
      const tNumber = 1;
      const tNumberTriviaModel = NumberTriviaModel(
        number: 1,
        text: 'test trivia',
      );
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test(
        'should check if the device is online',
        () {
          // arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer(
            (_) async => true,
          );

          // act
          repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockNetworkInfo.isConnected).called(1);
        },
      );

      group(
        'device is online',
        () {
          setUp(
            () {
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => true);
            },
          );

          test(
            'should return remote data when the call to remote data source us successful',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((_) async => tNumberTriviaModel);

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              verify(() => repositoryImpl.getConcreteNumberTrivia(tNumber));
              expect(result, const Right(tNumberTrivia));
            },
          );
        },
      );

      group(
        'device is offline',
        () {
          setUp(
            () {
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => false);
            },
          );
        },
      );
    },
  );
}

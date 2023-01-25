import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
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
        number: tNumber,
        text: 'test trivia',
      );
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test(
        'should check if the device is online',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) => Future.value(tNumberTriviaModel));
          when(() => mockNetworkInfo.isConnected).thenAnswer(
            (_) => Future.value(true),
          );
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) => Future.value());

          // act
          await repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockNetworkInfo.isConnected);
        },
      );

      group(
        'device is online',
        () {
          setUp(
            () {
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) => Future.value(true));
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((_) => Future.value());
            },
          );

          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((_) => Future.value(tNumberTriviaModel));

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(result, const Right(tNumberTrivia));
            },
          );

          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((_) => Future.value(tNumberTriviaModel));

              // act
              await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              verify(() =>
                      mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .called(1);
              verify(
                () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
              );
            },
          );

          test(
            'should return server failure exception when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenThrow(ServerException());

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, Left(ServerFailure()));
            },
          );
        },
      );

      group('device is offline', () {
        setUp(
          () {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((_) async => false);
          },
        );

        test(
          'should return last locally cached data when the cached data is present',
          () async {
            // arrange
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) => Future.value(tNumberTriviaModel));

            // act
            final result =
                await repositoryImpl.getConcreteNumberTrivia(tNumber);

            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(() => mockLocalDataSource.getLastNumberTrivia());
            expect(result, const Right(tNumberTrivia));
          },
        );

        test(
          'should return cache failure when the cached data is not present',
          () async {
            // arrange
            when(() => mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            // act
            final result =
                await repositoryImpl.getConcreteNumberTrivia(tNumber);

            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(() => mockLocalDataSource.getLastNumberTrivia());
            expect(result, Left(CacheFailure()));
          },
        );
      });
    },
  );
}

import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/impl/number_trivia_local_data_source_impl.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));

      test(
        'should return NumbterTrivia from SharedPreferences when there is one in the cache',
        () async {
          // arrange
          when(() => mockSharedPreferences.getString(any()))
              .thenAnswer((_) => fixture('trivia_cached.json'));

          // act
          final result = await dataSource.getLastNumberTrivia();

          // assert
          verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should throw cache exception when there is no cache value',
        () async {
          // arrange
          when(() => mockSharedPreferences.getString(any()))
              .thenAnswer((_) => null);

          // act
          final call = dataSource.getLastNumberTrivia;

          // assert
          expect(call, throwsA(const TypeMatcher<CacheException>()));
        },
      );
    },
  );

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: 'test trivia',
    );
    final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(() => mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA,
              expectedJsonString,
            )).thenAnswer((_) => Future.value(true));

        // act
        await dataSource.cacheNumberTrivia(tNumberTriviaModel);

        // assert
        verify(() => mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA,
              expectedJsonString,
            ));
      },
    );
  });
}

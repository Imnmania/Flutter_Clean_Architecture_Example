import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/impl/number_trivia_remote_data_source_impl.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the endpoint 
with application/json header''',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) => Future.value(
            http.Response(fixture('trivia.json'), 200),
          ),
        );

        // act
        dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {
                'content-type': 'application/json',
              },
            ));
      },
    );

    test(
      'should return a number trivia when the status code is 200 (success)',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) => Future.value(
            http.Response(
              fixture('trivia.json'),
              200,
            ),
          ),
        );

        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a server exception when the status code is not 200',
      () {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) => Future.value(
            http.Response('something went wrong!', 404),
          ),
        );

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the endpoint 
with application/json header''',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) => Future.value(
            http.Response(fixture('trivia.json'), 200),
          ),
        );

        // act
        dataSource.getRandomNumberTrivia();

        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/random'),
              headers: {
                'content-type': 'application/json',
              },
            ));
      },
    );

    test(
      'should return a number trivia when the status code is 200 (success)',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) => Future.value(
            http.Response(
              fixture('trivia.json'),
              200,
            ),
          ),
        );

        // act
        final result = await dataSource.getRandomNumberTrivia();

        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a server exception when the status code is not 200',
      () {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) => Future.value(
            http.Response('something went wrong!', 404),
          ),
        );

        // act
        final call = dataSource.getRandomNumberTrivia;

        // assert
        expect(call, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}

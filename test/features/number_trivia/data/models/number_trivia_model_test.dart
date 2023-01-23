import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(
    number: 42,
    text: 'Test text',
  );

  test(
    'should be a subclass of NumberTrivia entity',
    () {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'NumberTriviaModel fromJson',
    () {
      test(
        'should return a valid model when the Json number is an integer',
        () {
          // arrange
          final Map<String, dynamic> jsonMap = jsonDecode(
            fixture('trivia.json'),
          );

          // act
          final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the Json number is a double',
        () {
          // arrange
          final Map<String, dynamic> jsonMap = jsonDecode(
            fixture('trivia_double.json'),
          );

          // act
          final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'NumberTriviaModel toJson',
    () {
      test(
        'should return a Json map containing proper data',
        () {
          // act
          final result = tNumberTriviaModel.toJson();

          // assert
          final expectedMap = {
            'number': 42,
            'text': 'Test text',
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}

import '../../domain/entitites/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required int number,
    required String text,
  }) : super(
          text: text,
          number: number,
        );

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
    };
  }

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      number: (json['number'] as num).toInt(),
      text: json['text'],
    );
  }
}

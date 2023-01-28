import 'package:flutter/material.dart';

import '../../domain/entitites/number_trivia.dart';

class TriviaDisplayWidget extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplayWidget({
    super.key,
    required this.numberTrivia,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            numberTrivia.number.toString(),
            style: const TextStyle(fontSize: 50),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                numberTrivia.text,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

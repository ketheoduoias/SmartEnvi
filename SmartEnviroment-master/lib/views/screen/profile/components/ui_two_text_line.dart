import 'package:flutter/material.dart';

class TwoTextLine extends StatelessWidget {
  const TwoTextLine({
    Key? key,
    required this.textOne,
    required this.textTwo,
  }) : super(key: key);
  final String textOne;
  final String textTwo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(textOne, style: Theme.of(context).textTheme.titleMedium),
        Text(textTwo, style: Theme.of(context).textTheme.caption),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:outwork/widgets/buttons/main_feeling_button.dart';

class MainFeelingsRow extends StatelessWidget {
  const MainFeelingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MainFeelingButton(
            feeling: 'sad',
        ),
        MainFeelingButton(
          feeling: 'unhappy',
        ),
        MainFeelingButton(
          feeling: 'neutral',
        ),
        MainFeelingButton(
          feeling: 'happy',
        ),
        MainFeelingButton(
          feeling: 'veryhappy',
        ),
      ],
    );
  }
}

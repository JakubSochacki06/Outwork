import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SubsContainer extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  const SubsContainer({required this.title,required this.amount,required this.color});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        // border: themeProvider.isLightTheme()
        //     ? Border.all(color: Color(0xFFEDEDED))
        //     : Border(top:BorderSide(color: color, width: 4)),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: themeProvider.isLightTheme()
            ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(3, 3),
          ),
        ]
            : null,
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 3,
            color: color,
          ),
          const SizedBox(height: 15,),
          Center(child: Text(title, style: Theme.of(context).primaryTextTheme.labelLarge,)),
          Center(child: Text(amount, style: Theme.of(context).textTheme.bodyMedium,))
        ],
      ),
    );
  }
}

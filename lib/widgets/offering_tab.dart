import 'package:flutter/material.dart';

class OfferingTab extends StatelessWidget {
  final double priceTotal;
  final String planName;
  final String currencyCode;
  final double basicMonthlyPrice;
  final bool isSelected;
  const OfferingTab({required this.priceTotal, required this.planName, required this.currencyCode, required this.basicMonthlyPrice, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    double priceMonthly = 0;
    switch(planName){
      case '1 month':
        priceMonthly = priceTotal;
      case '3 months':
        priceMonthly = (priceTotal/3).roundToDouble();
      case '12 months':
        priceMonthly = (priceTotal/12).roundToDouble();
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary, width: 2)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(planName, style: Theme.of(context).textTheme.bodyLarge,),
              const Spacer(),
              Text('$currencyCode$priceMonthly / MO', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          priceMonthly!=priceTotal?Row(
            children: [
              Text(
                '$currencyCode${basicMonthlyPrice*int.parse(planName.split(' ')[0])}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.lineThrough, color: Theme.of(context).colorScheme.onPrimaryContainer, decorationColor: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              Text(' $currencyCode$priceTotal', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),)
            ],
          ):Container(),
        ],
      ),
    );
  }
}

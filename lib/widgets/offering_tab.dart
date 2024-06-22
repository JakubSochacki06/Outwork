import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class OfferingTab extends StatelessWidget {
  final double priceTotal;
  final String currencyCode;
  final double basicMonthlyPrice;
  final bool isSelected;
  final PackageType packageType;
  const OfferingTab({required this.priceTotal, required this.currencyCode, required this.basicMonthlyPrice, required this.isSelected, required this.packageType});

  @override
  Widget build(BuildContext context) {
    String priceMonthly = "";
    String planName = "";
    switch(packageType){
      case PackageType.monthly:
        planName = '1 month';
      case PackageType.threeMonth:
        planName = '3 months';
      case PackageType.annual:
        planName = '12 months';
      default:
        planName = "Error";
    }
    switch(planName){
      case '1 month':
        priceMonthly = priceTotal.toStringAsFixed(2);
      case '3 months':
        print("PRICE MONTHLY");
        priceMonthly = (priceTotal/3).toStringAsFixed(2);
        print(priceMonthly);
      case '12 months':
        priceMonthly = (priceTotal/12).toStringAsFixed(2);
    }

    String getLocalizedPlanName(String planName) {
      if(planName == ""){

      }
      switch (planName) {
        case "1 month":
          return AppLocalizations.of(context)!.oneMonth;
        case "3 months":
          return AppLocalizations.of(context)!.months2(3);
        case "12 months":
          return AppLocalizations.of(context)!.months2(12);
        default:
          return planName; // Fallback to the original name if not found
      }
    }

    print(planName);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.primary, width: 2)
      ),
      child: Column(
        children: [
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Container(
          //     padding: const EdgeInsets.all(5),
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).colorScheme.secondary,
          //       borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
          //     ),
          //     child: Text('25% off', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),),
          //   ),
          // ),
          Row(
            children: [
              Text(getLocalizedPlanName(planName), style: Theme.of(context).textTheme.bodyLarge,),
              const Spacer(),
              Text('$currencyCode$priceMonthly / ${AppLocalizations.of(context)!.monthShortcut}', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          double.parse(priceMonthly)!=priceTotal?Row(
            children: [
              Text(
                '$currencyCode${(basicMonthlyPrice*int.parse(planName.split(' ')[0])).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.lineThrough, color: Theme.of(context).colorScheme.onPrimaryContainer, decorationColor: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              Text(' $currencyCode${priceTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),)
            ],
          ):Container(),
        ],
      ),);
  }
}

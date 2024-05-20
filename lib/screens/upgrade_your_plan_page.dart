import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import '../providers/user_provider.dart';
import '../widgets/offering_tab.dart';

class UpgradeYourPlanPage extends StatefulWidget {
  final Offerings offerings;

  const UpgradeYourPlanPage({required this.offerings});

  @override
  State<UpgradeYourPlanPage> createState() => _UpgradeYourPlanPageState();
}

class _UpgradeYourPlanPageState extends State<UpgradeYourPlanPage> {
  int selectedOffering = 2;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))),
              // Lottie.asset('assets/upgrade.json', height: height * 0.2),
              SizedBox(
                height: height * 0.01,
              ),
              AutoSizeText(
                'Try Outwork for free',
                style: Theme.of(context).textTheme.displaySmall,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Flexible(
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashFactory: NoSplash.splashFactory,
                      onTap: () {
                        setState(() {
                          selectedOffering = index;
                        });
                      },
                      child: OfferingTab(
                        isSelected: index == selectedOffering,
                        priceTotal: widget.offerings.current!
                            .availablePackages[index].storeProduct.price,
                        planName: widget.offerings.current!
                            .availablePackages[index].storeProduct.description,
                        currencyCode: widget.offerings.current!
                            .availablePackages[index].storeProduct.currencyCode,
                        basicMonthlyPrice: widget
                            .offerings.current!.monthly!.storeProduct.price,
                      ),
                    );
                  },
                  itemCount: 3,
                  separatorBuilder: (context, builder) {
                    return SizedBox(
                      height: height * 0.015,
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.07,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      CustomerInfo customerInfo =
                          await Purchases.purchasePackage(widget.offerings
                              .current!.availablePackages[selectedOffering]);
                      if (customerInfo
                          .entitlements.all[entitlementRCID]!.isActive) {
                        userProvider.upgradeAccount(context);
                      }
                    } catch (e) {
                      print(e);
                      // var errorCode = PurchasesErrorHelper.getErrorCode(e);
                    }
                  },
                  child: Text(
                    selectedOffering != 0
                        ? '14 Days Free trial'
                        : '7 Days Free trial',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text('Recurring billing, cancel anytime. ',
                  style: Theme.of(context).primaryTextTheme.labelMedium, textAlign: TextAlign.center,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Terms & Conditions',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String url =
                              'https://sites.google.com/view/outwork-terms-conditions/strona-g%C5%82%C3%B3wna';
                          await launchUrl(Uri.parse(url));
                        }),
                  TextSpan(
                      text: ' • ',
                      style: Theme.of(context).primaryTextTheme.labelMedium),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String url =
                              'https://sites.google.com/view/outwork-privacy-policy/strona-g%C5%82%C3%B3wna';
                          await launchUrl(Uri.parse(url));
                        }),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

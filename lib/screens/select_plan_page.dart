import 'package:flutter/material.dart';
import 'package:outwork/constants/constants.dart';
import 'package:outwork/widgets/offering_tab.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../providers/user_provider.dart';

class SelectPlanPage extends StatefulWidget {
  final Offerings offerings;

  const SelectPlanPage({required this.offerings});

  @override
  State<SelectPlanPage> createState() => _SelectPlanPageState();
}

class _SelectPlanPageState extends State<SelectPlanPage> {
  int selectedOffering = 2;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.02, left: width * 0.04, right: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                iconSize: width * 0.07,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary)),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.navigate_before),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Enjoy your',
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: ' 14 day free trial ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      TextSpan(
                        text: 'with any plan!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ]),
              ),
              Flexible(
                child: ListView.separated(
                  reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashFactory: NoSplash.splashFactory,
                      onTap: (){
                        setState(() {
                          selectedOffering = index;
                        });
                      },
                      child: OfferingTab(
                        isSelected: index==selectedOffering,
                        priceTotal: widget.offerings
                            .current!.availablePackages[index].storeProduct.price,
                        planName: widget.offerings.current!.availablePackages[index]
                            .storeProduct.description,
                        currencyCode: widget.offerings.current!.availablePackages[index]
                            .storeProduct.currencyCode,
                        basicMonthlyPrice:
                            widget.offerings.current!.monthly!.storeProduct.price,
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
              Column(
                children: [
                  Text(
                    'Recurring billing, cancel anytime.',
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.07,
                    child: ElevatedButton(
                      onPressed: () async{
                        try {
                          await Purchases.logIn(userProvider.user!.email!);
                          CustomerInfo customerInfo = await Purchases.purchasePackage(widget.offerings.current!.availablePackages[selectedOffering]);
                          if (customerInfo.entitlements.all[entitlementRCID]!.isActive) {
                            userProvider.upgradeAccount(context);
                          }
                        } catch (e) {
                          print(e);
                          // var errorCode = PurchasesErrorHelper.getErrorCode(e);
                        }
                      },
                      child: Text(
                        'START MY FREE TRIAL',
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
                    height: height * 0.02,
                  ),
                  Text(
                    'You will be automatically billed at the end of your free trial for the subscription term and price you have selected unless you cancel at least 24 hours prior to the end of your free trial. You may cancel anytime in Google Play.',
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

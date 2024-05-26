import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/subscription_carousel_item.dart';
import 'package:outwork/constants/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../upgrade_your_plan_page.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  int _currentIndex = 0;
  int increment = 0;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double basePrice = subscriptions[_currentIndex]['price'];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: IconButton(
                iconSize: width * 0.07,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary)),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.navigate_before),
              ),
            ),
            Text('Add new subscription', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,),
            SizedBox(height: height*0.025,),
            Container(
              height: height*0.35,
              child: CarouselSlider.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index, pageViewIndex) {
                  return SubscriptionCarouselItem(name: subscriptions[index]['name'],);
                },
                options: CarouselOptions(
                  height: height * 0.4,
                  viewportFraction: 0.66,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                      increment = 0;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.04),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly price', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: (){
                            setState(() {
                              if((basePrice+increment)>1){
                                increment--;
                              }
                            });
                          },
                          icon: Icon(Icons.remove, color: Theme.of(context).colorScheme.onBackground,),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.background,
                            elevation: 0,
                          ),
                        ),
                        AnimatedFlipCounter(
                          duration: const Duration(milliseconds: 500),
                          textStyle: Theme.of(context).textTheme.displayMedium,
                          fractionDigits: 2,
                          suffix: '\$',
                          value: increment==0?basePrice:basePrice+increment,
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              increment++;
                            });
                          },
                          icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onBackground,),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.background,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            errorStyle: Theme.of(context)
                                .primaryTextTheme
                                .labelLarge!
                                .copyWith(color: Theme.of(context).colorScheme.error),
                            // alignLabelWithHint: true,
                            labelText: 'Description (optional)',
                            labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                            hintText: 'Why do you need it?'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async{
                        if(userProvider.user!.isPremiumUser! || progressProvider.subscriptions.length < 2){
                          await progressProvider.addSubscriptionToDatabase(
                              {
                                'name':subscriptions[_currentIndex]['name'],
                                'price':basePrice+increment,
                              }, userProvider.user!.email!);
                          Navigator.pop(context);
                        } else {
                          Offerings? offerings;
                          try {
                            offerings = await Purchases.getOfferings();
                          } catch (e) {
                            print(e);
                          }
                          if (offerings != null) {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: UpgradeYourPlanPage(
                                offerings: offerings,
                              ),
                              withNavBar: false,
                            );
                          }
                        }
                      },
                      child: Text(
                        'Add this subscription',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(width * 0.8, height * 0.05),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

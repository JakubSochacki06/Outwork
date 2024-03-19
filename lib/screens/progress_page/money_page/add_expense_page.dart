import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:outwork/widgets/subscription_carousel_item.dart';
import 'package:outwork/constants/constants.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                icon: Icon(Icons.navigate_before),
              ),
            ),
            Text('Add new subscription', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,),
            SizedBox(height: height*0.025,),
            Container(
              height: height*0.3,
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
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                ),
                child: Column(
                  children: [
                    Text(subscriptions[_currentIndex]['name']),
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

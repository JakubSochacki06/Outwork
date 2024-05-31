import 'package:flutter/material.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/progress_page/money_page/add_expense_page.dart';
import 'package:outwork/screens/progress_page/money_page/popups/edit_expenses_settings_popup.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:outwork/widgets/subs_container.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    Future<bool?> wantToDeleteSubAlert(BuildContext context) async {
      bool? deleteSub = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete this subscription?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            content: Text('Are you sure you want to delete this subscription?',
                style: Theme.of(context).primaryTextTheme.bodySmall),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No', style: Theme.of(context).textTheme.bodySmall),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          );
        },
      );
      return deleteSub;
    }

    // print((progressProvider.sumExpenses()/progressProvider.subLimit * 100).toInt());
    return Scaffold(
      appBar: const MainAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.02, horizontal: width * 0.04),
        child: Column(
          children: [
            Row(
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
                TextButton(
                  child: Text('Add new',
                      style: Theme.of(context).primaryTextTheme.bodyMedium),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const AddExpensePage(),
                      withNavBar: true,
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          // height: height*0.1,
                          padding: EdgeInsets.only(
                              bottom:
                              MediaQuery.of(context).viewInsets.bottom),
                          child: const EditExpensesPopup(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
            ),
            // SizedBox(height: height*0.02,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     SubsContainer(title: 'Highest bill', amount: '\$12.99', color: Theme.of(context).colorScheme.error),
            //     SubsContainer(title: 'Active subs', amount: '12', color: Theme.of(context).colorScheme.secondary),
            //     SubsContainer(title: 'Highest sub', amount: '\$19.99', color: Theme.of(context).colorScheme.error),
            //   ],
            // ),
            // SizedBox(height: height*0.01,),
            SfRadialGauge(
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                  canScaleToFit: true,
                  axisLineStyle: AxisLineStyle(
                    cornerStyle: CornerStyle.bothCurve,
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 0.12,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  showTicks: false,
                  showLabels: false,
                  minimum: 0,
                  maximum: progressProvider.subLimit.toDouble(),
                  annotations: [
                    GaugeAnnotation(
                      angle: 90,
                      widget: Text(
                        '${progressProvider.sumExpenses()}\$\n',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: progressProvider.sumExpenses()<progressProvider.subLimit?Theme.of(context).colorScheme.onBackground:Theme.of(context).colorScheme.error,),
                      ),
                    ),
                    GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.08,
                      widget: Text(
                        'Spent this month',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    ),
                    GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.75,
                      widget: Text(
                        '${(progressProvider.sumExpenses()/progressProvider.subLimit * 100).toInt()}% Limit',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: progressProvider.sumExpenses()<progressProvider.subLimit?Theme.of(context).colorScheme.onBackground:Theme.of(context).colorScheme.error,),
                      ),
                    ),
                  ],
                  pointers: <GaugePointer>[
                    RangePointer(
                      cornerStyle: CornerStyle.bothCurve,
                      // enableAnimation: true,
                      value: progressProvider.sumExpenses(),
                      width: 20,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      color: progressProvider.sumExpenses()<progressProvider.subLimit?Theme.of(context).colorScheme.secondary:Theme.of(context).colorScheme.error,
                      // gradient: SweepGradient(
                      //     colors: [Theme.of(context).colorScheme.error, Theme.of(context).colorScheme.secondary],
                      // stops: <double>[0.25, 0.75]
                      // ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SubsContainer(
                    title: 'Lowest sub',
                    amount: '${progressProvider.findLowestSub()}\$',
                    color: Theme.of(context).colorScheme.error),
                SubsContainer(
                    title: 'Active subs',
                    amount: progressProvider.subscriptions.length.toString(),
                    color: Theme.of(context).colorScheme.secondary),
                SubsContainer(
                    title: 'Highest sub',
                    amount: '${progressProvider.findHighestSub()}\$',
                    color: Theme.of(context).colorScheme.error),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: progressProvider.subscriptions.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width*0.05),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius:BorderRadius.circular(10),
                        child: Container(
                          height:width*0.1,
                          width: width*0.1,
                          child: Image.asset(
                              'assets/images/${progressProvider.subscriptions[index]['name']}.png'),
                        ),
                      ),
                      SizedBox(width: width*0.03,),
                      Expanded(
                        child: Text(
                          progressProvider.subscriptions[index]['name'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        '${progressProvider.subscriptions[index]['price']}\$',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(width: width*0.025,),
                      InkWell(
                        onTap:() async{
                          bool? wantToDelete = await wantToDeleteSubAlert(context);
                          if(wantToDelete == true){
                            await progressProvider.removeSubscriptionFromDatabase(progressProvider.subscriptions[index], userProvider.user!.email!);
                          }
                        },
                        child: const Icon(Icons.delete),
                      )
                    ]),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: height * 0.01,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

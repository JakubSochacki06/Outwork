import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/screens/progress_page/add_new_expense_popup.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:outwork/widgets/subs_container.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MainAppBar(),
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
                  icon: Icon(Icons.navigate_before),
                ),
                TextButton(
                  child:Text('Add new', style: Theme.of(context).primaryTextTheme.bodyMedium),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: (){
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          // height: height*0.1,
                          padding: EdgeInsets.only(
                              bottom:
                              MediaQuery.of(context).viewInsets.bottom),
                          child: AddNewExpensePopup(),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.settings),
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
                    thickness: 0.12,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  showTicks: false,
                  showLabels: false,
                  minimum: 0,
                  maximum: 1000,
                  annotations: [
                    GaugeAnnotation(
                      angle: 90,
                      widget: Text(
                        '\$1,000\n',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.08,
                      widget: Text(
                        'Spent this month',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ],
                  pointers: <GaugePointer>[
                    RangePointer(
                      cornerStyle: CornerStyle.bothCurve,
                      // enableAnimation: true,
                      value: 750,
                      width: 20,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      color: Theme.of(context).colorScheme.secondary,
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
                SubsContainer(title: 'Highest bill', amount: '\$12.99', color: Theme.of(context).colorScheme.error),
                SubsContainer(title: 'Active subs', amount: '12', color: Theme.of(context).colorScheme.secondary),
                SubsContainer(title: 'Highest sub', amount: '\$19.99', color: Theme.of(context).colorScheme.error),
              ],
            ),
            Text('Track your expenses')
          ],
        ),
      ),
    );
  }
}

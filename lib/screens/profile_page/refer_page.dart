import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:outwork/models/monthlyRevenue.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/widgets/appBars/refer_bar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';
import '../../providers/user_provider.dart';
import '../../widgets/refer_tile.dart';

class ReferPage extends StatefulWidget {
  const ReferPage({super.key});

  @override
  State<ReferPage> createState() => _ReferPageState();
}

class _ReferPageState extends State<ReferPage> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        header: null,
        canShowMarker: false,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
              ),
              child: Text(
                '\$${data.amount.toString()}',
                style: Theme.of(context).textTheme.labelMedium,
              ));
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
        child: Scaffold(
      appBar: const ReferAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          bottom: height * 0.02,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                border: themeProvider.isLightTheme()
                    ? Border.all(color: const Color(0xFFEDEDED))
                    : null,
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
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '30%',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: 'Earn 30% for ',
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'EVERY ',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                            TextSpan(
                              text: 'referral that has active subscription.',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                  sigmaX: 0, sigmaY: 0, tileMode: TileMode.decal),
              child: Stack(
                children: [
                  Container(
                    height: height * 0.23,
                    child: SfCartesianChart(
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                          labelFormat: '\${value}',
                          majorTickLines: const MajorTickLines(size: 1)),
                      title: ChartTitle(
                          text: 'Monthly revenue',
                          textStyle: Theme.of(context).textTheme.bodyLarge),
                      legend: const Legend(isVisible: false),
                      series: <ColumnSeries<MonthlyRevenue, String>>[
                        ColumnSeries<MonthlyRevenue, String>(
                          enableTooltip: true,
                          dataSource: <MonthlyRevenue>[
                            MonthlyRevenue(20, 'Dec'),
                            MonthlyRevenue(30, 'Jan'),
                            MonthlyRevenue(15, 'Feb'),
                            MonthlyRevenue(40, 'Mar'),
                            MonthlyRevenue(60, 'Apr'),
                            MonthlyRevenue(110, 'May'),
                          ],
                          dataLabelSettings: const DataLabelSettings(),
                          color: Theme.of(context).colorScheme.secondary,
                          width: 0.3,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          xValueMapper: (MonthlyRevenue revenue, _) =>
                              revenue.month,
                          yValueMapper: (MonthlyRevenue revenue, _) =>
                              revenue.amount,
                          // Enable data labe
                        )
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: width*0.65,
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.01),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.45),
                          border: Border.all(color: Theme.of(context).colorScheme.error),
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
                        child: Text('This is preview of referral program. It doesn\'t work for now!!', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.bodySmall,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  '\$${userProvider.user!.refBalance.toString()}',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                InkWell(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: themeProvider.isLightTheme()
                          ? Border.all(color: const Color(0xFFEDEDED))
                          : null,
                      // color: Color(0xFFF0F2F5),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      boxShadow: themeProvider.isLightTheme()
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                // blurRadius: 10,
                                offset: const Offset(3, 3),
                              )
                            ]
                          : null,
                    ),
                    child: const Text('Withdraw'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 2,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                    child: AutoSizeText(
                      'https://link.to/REFCODE',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Clipboard.setData(const ClipboardData(
                                text: "https://link.to/REFCODE"))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Copied to your clipboard !')));
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          border: themeProvider.isLightTheme()
                              ? Border.all(color: const Color(0xFFEDEDED))
                              : null,
                          // color: Color(0xFFF0F2F5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: themeProvider.isLightTheme()
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    // blurRadius: 10,
                                    offset: const Offset(3, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: const Text(
                          'Copy',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Text(
                  'Or share via',
                  style: Theme.of(context).primaryTextTheme.labelLarge,
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.primary),
                    child: Icon(
                      LineIcons.facebookF,
                      color: Theme.of(context).colorScheme.secondary,
                      size: height * 0.035,
                    )),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.primary),
                    child: Icon(
                      LineIcons.linkedinIn,
                      size: height * 0.035,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.primary),
                    child: Icon(
                      LineIcons.instagram,
                      size: height * 0.035,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.primary),
                    child: Icon(
                      LineIcons.whatSApp,
                      size: height * 0.035,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.primary),
                    child: Icon(
                      LineIcons.facebookMessenger,
                      color: Theme.of(context).colorScheme.secondary,
                      size: height * 0.035,
                    )),
              ),
            ]),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                Text(
                  'How it works',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            const ReferTile(
              imagePath: 'refer',
              title: 'Step 1',
              description: 'Share your referral link/code with your friends',
            ),
            SizedBox(
              height: height * 0.01,
            ),
            const ReferTile(
              imagePath: 'sub',
              title: 'Step 2',
              description: 'Your friend upgrades his subscription to PRO',
            ),
            SizedBox(
              height: height * 0.01,
            ),
            const ReferTile(
              imagePath: 'earn',
              title: 'Step 3',
              description:
                  'You earn 30% for every friend with active subscription',
            ),
          ],
        ),
      ),
    ));
  }
}

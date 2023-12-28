import 'package:flutter/material.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/screens/add_project_page.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          label: Text('Add new project',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer)
          ),
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
                  child: AddProjectPage(),
                ),
              ),
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: EdgeInsets.only(
              top: height * 0.02, left: width * 0.04, right: width * 0.04),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Keep on grinding',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Outwork all of them.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                height: height * 0.15,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: themeProvider.isLightTheme()
                        ? Border.all(color: Color(0xFFEDEDED))
                        : null,
                    // color: Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: themeProvider.isLightTheme()
                        ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(3, 3),
                            )
                          ]
                        : null),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('${DateTime.now().day}',
                            style: Theme.of(context).textTheme.displayLarge),
                        Text(months[DateTime.now().month - 1],
                            style: Theme.of(context).textTheme.headlineSmall)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your projects',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.0,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      height: height*0.15,
                      // width: width*0.4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        border: themeProvider.isLightTheme()?Border.all(color: Color(0xFFEDEDED)):null,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: themeProvider.isLightTheme()?[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(3, 3),
                          ),
                        ]:null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

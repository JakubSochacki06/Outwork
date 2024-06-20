import 'package:flutter/material.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';
import 'package:outwork/widgets/carousel_item.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:outwork/constants/constants.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    List<Map<String, dynamic>> progressFields = getProgressFields(context);
    return Scaffold(
      appBar: const MainAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: height * 0.02, left: width * 0.04, right: width * 0.04),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: width / (height / 1.76),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: progressFields.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: progressFields[index]['route']!=null?(){
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: progressFields[index]['route'],
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }:() {
                final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'On Snap!',
                    message:
                    'This feature is not ready yet :(\n We will add it soon!',
                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              },
              child: ProgressCard(
                  title: progressFields[index]['title']!,
                  description: progressFields[index]['description']!,
                  icon: progressFields[index]['icon']!,
              ),
            );
          },),
      ),
    );
  }
}



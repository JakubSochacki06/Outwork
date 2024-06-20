import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:outwork/widgets/login_register_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: Image.asset('assets/logo_login.png',)),
                        SizedBox(height: height*0.005,),
                        Text(AppLocalizations.of(context)!.number1App, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
                        SizedBox(height: height*0.03,),
                        const LoginRegisterForm(),
                        SizedBox(height: height*0.01,),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: AppLocalizations.of(context)!.byCreatingAccount,
                                    style: Theme.of(context).primaryTextTheme.labelMedium
                                ),
                                TextSpan(
                                    text: AppLocalizations.of(context)!.terms,
                                    style: Theme.of(context).textTheme.labelMedium,
                                    recognizer: TapGestureRecognizer()..onTap = () async{
                                      String url = 'https://sites.google.com/view/outwork-terms-conditions/strona-g%C5%82%C3%B3wna';
                                      await launchUrl(Uri.parse(url));
                                    }
                                ),
                                TextSpan(
                                    text: ' ${AppLocalizations.of(context)!.and} ',
                                    style: Theme.of(context).primaryTextTheme.labelMedium
                                ),
                                TextSpan(
                                    text: AppLocalizations.of(context)!.privacy,
                                    style: Theme.of(context).textTheme.labelMedium,
                                    recognizer: TapGestureRecognizer()..onTap = () async{
                                      String url = 'https://sites.google.com/view/outwork-privacy-policy/strona-g%C5%82%C3%B3wna';
                                      await launchUrl(Uri.parse(url));
                                    }
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



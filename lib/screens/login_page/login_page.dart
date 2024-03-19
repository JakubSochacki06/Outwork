import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:outwork/widgets/login_register_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
          child: Column(
            children: [
              Image.asset('assets/logo_login.png', scale: 5,),
              SizedBox(height: height*0.02,),
              Expanded(child: Image.asset('assets/images/login.png')),
              SizedBox(height: height*0.005,),
              AutoSizeText('#1 Self-improvement mobile app', style: Theme.of(context).textTheme.bodyMedium, maxLines: 1,),
              SizedBox(height: height*0.02,),
              LoginRegisterForm(),
              SizedBox(height: height*0.01,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'By creating an account, you are agreeing to our ',
                      style: Theme.of(context).primaryTextTheme.labelMedium
                    ),
                    TextSpan(
                        text: 'Terms & Conditions',
                        style: Theme.of(context).textTheme.labelMedium,
                      recognizer: TapGestureRecognizer()..onTap = () async{
                          String url = 'https://sites.google.com/view/outwork-terms-conditions/strona-g%C5%82%C3%B3wna';
                          await launchUrl(Uri.parse(url));
                      }
                    ),
                    TextSpan(
                        text: ' and ',
                        style: Theme.of(context).primaryTextTheme.labelMedium
                    ),
                    TextSpan(
                        text: 'Privacy Policy',
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
        )
      ),
    );
  }
}

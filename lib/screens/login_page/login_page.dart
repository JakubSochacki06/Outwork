import 'package:flutter/material.dart';
import 'package:outwork/widgets/login_register_form.dart';

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
              Spacer(),
              LoginRegisterForm()
            ],
          ),
        )
      ),
    );
  }
}

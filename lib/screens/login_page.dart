import 'package:flutter/material.dart';
import 'package:outwork/widgets/loginRegisterForm.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // First Container
            Container(
              height: height * 0.3, // Adjust the height as needed
              color: Color(0xFF111315),
              child: Center(
                child: Text(
                  'First Container',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width:0)
                  )
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Color(0xFF111315),
                      ),
                    ),
                    Container(
                      width: width,
                      // height:height*0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        color: Colors.white,
                      ),
                      child: LoginRegisterForm(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

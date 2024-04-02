import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: width,
                height: height / 2,
              ),
              Container(
                width: width,
                height: height / 2.3,
                decoration: const BoxDecoration(
                  color: const Color(0xFF080e1c),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  ),
                ),
              ),
              Positioned(
                top: height / 3,
                left: width / 3.15,
                // W razie potrzeby usunięcia bordera z avatara należy usunąć pierwszy CircleAvatar
                child: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFFF6F7F9),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/images/logoOutwork3.png'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height*0.02,
          ),
          const Text(
            'Outwork',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: height*0.1,
          ),
          const Text(
            'Outwork all of them\nStop procrastinating\nMake it f*cking happen.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: height*0.01,
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Wypróbuj za darmo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.white,
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color(0xFF71C9CE),
                elevation: 0,
                fixedSize: Size(width = 200, height = 50)),
          )
        ],
      ),
    );
  }
}
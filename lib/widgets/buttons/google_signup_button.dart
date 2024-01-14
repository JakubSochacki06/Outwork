import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class GoogleSignupButton extends StatelessWidget {
  const GoogleSignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.white,
          minimumSize: Size(50, 60),
          side: const BorderSide(
            color: Colors.black26,
          ),
          elevation: 0,
        ),
        onPressed: () {
          final provider = Provider.of<UserProvider>(context, listen: false);
          provider.signInWithGoogle();
          Navigator.pushNamed(context, '/processingLogging');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(backgroundImage: AssetImage('assets/images/googleLogo.png'), backgroundColor: Color(0x100FFFFF), radius: 13,),
            SizedBox(
              width: 10,
            ),
            Text('Google', style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class GoogleSignupButton extends StatelessWidget {
  const GoogleSignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: Size(50, 60),
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
          CircleAvatar(backgroundImage: AssetImage('assets/images/googleLogo.png'), radius: 13,),
          SizedBox(
            width: 10,
          ),
          Text('Continue with google', style: Theme.of(context).textTheme.bodySmall,)
        ],
      ),
    );
  }
}

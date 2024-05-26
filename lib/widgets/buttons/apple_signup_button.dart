import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

class AppleSignupButton extends StatelessWidget {
  const AppleSignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(50, 60),
        elevation: 0,
      ),
      onPressed: () {
        final provider = Provider.of<UserProvider>(context, listen: false);
        provider.signInWithGoogle(context);
        Navigator.pushNamed(context, '/processingLogging');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apple, color: Colors.white, size: 35,),
          // const CircleAvatar(backgroundImage: AssetImage('assets/images/appleLogo.png'), radius: 13,),
          const SizedBox(
            width: 10,
          ),
          Text('Continue with Apple', style: Theme.of(context).textTheme.bodySmall,)
        ],
      ),
    );
  }
}

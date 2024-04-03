import 'package:flutter/material.dart';
import 'package:outwork/widgets/buttons/google_signup_button.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginRegisterForm extends StatefulWidget {
  const LoginRegisterForm({super.key});

  @override
  State<LoginRegisterForm> createState() => _LoginRegisterFormState();
}

class _LoginRegisterFormState extends State<LoginRegisterForm> {
  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;
  bool showPassword = false;
  bool loginActive = true;
  String? emailError;
  String? passwordError;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ToggleSwitch(
          minWidth: double.infinity,
          minHeight: height * 0.06,
          cornerRadius: 15,
          activeBgColors: [
            [Theme.of(context).colorScheme.secondary],
            [Theme.of(context).colorScheme.secondary]
          ],
          activeFgColor: Theme.of(context).colorScheme.onSecondaryContainer,
          inactiveBgColor: Theme.of(context).colorScheme.primary,
          inactiveFgColor: Colors.white,
          initialLabelIndex: loginActive ? 0 : 1,
          totalSwitches: 2,
          labels: const ['Login', 'Register'],
          radiusStyle: true,
          onToggle: (index) {
            if (index == 0) {
              setState(() {
                loginActive = true;
              });
            } else {
              setState(() {
                loginActive = false;
              });
            }
          },
        ),
        SizedBox(
          height: height * 0.015,
        ),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.text,
          focusNode: _emailFocus,
          onTap: () {
            setState(() {
              FocusScope.of(context).requestFocus(_emailFocus);
            });
          },
          decoration: InputDecoration(
            errorText: emailError,
            labelText: 'Email Address',
            labelStyle: Theme.of(context).textTheme.labelLarge,
            floatingLabelStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(
                    color: _emailFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary),
            prefixIcon: const Icon(
              Icons.email_outlined,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2),
            ),
          ),
        ),
        SizedBox(
          height: height * 0.015,
        ),
        TextField(
          controller: _passwordController,
          keyboardType: TextInputType.text,
          focusNode: _passwordFocus,
          onTap: () {
            setState(() {
              FocusScope.of(context).requestFocus(_passwordFocus);
            });
          },
          obscureText: !showPassword,
          decoration: InputDecoration(
            labelStyle: Theme.of(context).textTheme.labelLarge,
            floatingLabelStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(
                    color: _passwordFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary),
            errorText: passwordError,
            suffixIcon: IconButton(
              icon: !showPassword == false
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
            labelText: 'Password',
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2),
            ),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Container(
          height: height * 0.07,
          child: ElevatedButton(
            onPressed: () async {
              _passwordController.text.length < 8
                  ? passwordError = 'Password must have atleast 8 characters!'
                  : passwordError = null;
              !_emailController.text.contains("@")
                  ? emailError = 'Email must be valid!'
                  : emailError = null;
              if (passwordError != null || emailError != null) {
                setState(() {});
                return;
              }
              final provider =
                  Provider.of<UserProvider>(context, listen: false);
              if (loginActive) {
                await provider.loginWithEmailPassword(
                    _emailController.text, _passwordController.text, context);
              } else {
                await provider.registerWithEmailPassword(
                    _emailController.text, _passwordController.text);
              }
              Navigator.pushNamed(context, '/processingLogging');
            },
            child: Text(
              loginActive ? 'Login' : 'Register',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
            ),
          ),
        ),
        SizedBox(
          height: height * 0.015,
        ),
        Row(
          children: [
            Expanded(
              child: Divider(
                height: 1,
                thickness: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(
              width: width * 0.025,
            ),
            Text(
              loginActive ? 'or login with' : 'or register with',
              style: Theme.of(context).primaryTextTheme.labelLarge,
            ),
            SizedBox(
              width: width * 0.025,
            ),
            Expanded(
              child: Divider(
                height: 1,
                thickness: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.015,
        ),
        const GoogleSignupButton(),
      ],
    );
  }
}

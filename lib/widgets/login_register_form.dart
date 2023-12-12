import 'package:flutter/material.dart';
import 'package:outwork/widgets/buttons/google_signup_button.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
bool loginActive = true;
class LoginRegisterForm extends StatefulWidget {
  const LoginRegisterForm({super.key});

  @override
  State<LoginRegisterForm> createState() => _LoginRegisterFormState();
}

class _LoginRegisterFormState extends State<LoginRegisterForm> {

  bool registerActive = false;
  bool showPassword = false;
  String? emailError;
  String? passwordError;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: height*0.03,),
          Container(
            height: height * 0.08,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.07,
                  width: width * 0.47,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loginActive = true;
                        registerActive = false;
                      });
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: loginActive ? Colors.black : Colors.grey,
                          fontSize: 16),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0.0),
                      backgroundColor: loginActive
                          ? MaterialStateProperty.all<Color>(Colors.white)
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade200),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height*0.05,),
                Container(
                  height: height * 0.07,
                  width: width * 0.47,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loginActive = false;
                        registerActive = true;
                      });
                    },
                    child: Text('Register',
                        style: TextStyle(
                            color: registerActive ? Colors.black : Colors.grey,
                            fontSize: 16)),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0.0),
                      backgroundColor: registerActive
                          ? MaterialStateProperty.all<Color>(Colors.white)
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade200),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height*0.05,),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.text,
            onChanged: (xd) {},
            decoration: InputDecoration(
              errorText: emailError,
              labelText: 'Email Address',
              labelStyle: TextStyle(color: Color(0xFF2A6049)),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Color(0xFF2A6049),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2A6049), width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.black12),
              ),
            ),
          ),
          SizedBox(height: height*0.03,),
          TextField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            onChanged: (xd) {},
            obscureText: !showPassword,
            decoration: InputDecoration(
              errorText: passwordError,
              suffixIcon: IconButton(
                color: Color(0xFF2A6049),
                icon: !showPassword == false
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
              labelText: 'Password',
              floatingLabelStyle: TextStyle(color: Color(0xFF2A6049)),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF2A6049),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2A6049), width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.black12),
              ),
            ),
          ),
          SizedBox(height: height*0.05,),
          Container(
            height: height * 0.07,
            child: ElevatedButton(
              onPressed: () async{
                _passwordController.text.length < 8? passwordError = 'Password must have atleast 8 characters!': passwordError = null;
                !_emailController.text.contains("@")? emailError = 'Email must be valid!': emailError = null;
                if(passwordError != null || emailError != null){
                  setState(() {});
                  return;
                }
                final provider = Provider.of<UserProvider>(context, listen: false);
                if(loginActive){
                  await provider.loginWithEmailPassword(_emailController.text, _passwordController.text);
                }else{
                  await provider.registerWithEmailPassword(_emailController.text, _passwordController.text);
                }
                Navigator.pushNamed(context, '/processingLogging');
              },
              child: Text(
                loginActive ? 'Login' : 'Register',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Color(0xFF2A6049),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: height*0.03,),
          Row(
            children: [
              Expanded(
                child: Divider(
                  height: 1,
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                width: width*0.025,
              ),
              Text(loginActive?'or login with':'or register with'),
              SizedBox(
                width: width*0.025,
              ),
              Expanded(
                child: Divider(
                  height: 1,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
          SizedBox(height: height*0.03,),
          Row(
            children: [
              GoogleSignupButton(),
              SizedBox(width: width*0.04,),
              GoogleSignupButton(),
            ],
          )
        ],
      ),
    );
  }
}

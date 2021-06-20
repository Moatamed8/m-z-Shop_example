import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shop/config/color_config.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers/auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  bool hidePassword = true;

  bool _isLoading = false;

  bool isSignupScreen = true;

  bool isRememberMe = false;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> submit() async {
    final isValid = _formKey.currentState.validate();
    //for close keyboard
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      try {
        if (isSignupScreen) {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<AuthProvider>(context, listen: false)
              .signUp(_authData['email'], _authData['password']);
        } else {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<AuthProvider>(context, listen: false)
              .logIn(_authData['email'], _authData['password']);
        }
      } on HttpException catch (e) {
        var errorMessage = 'Authentication failed';
        if (e.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use';
        } else if (e.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not valid email address ';
        } else if (e.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak ';
        } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'could not found a user with that email';
        } else if (e.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password ';
        }
        _showDialogError(errorMessage);
      } catch (e) {
        const errorMessage = '';
        _showDialogError(errorMessage);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showDialogError(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Authentication failed,Please try again"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), child: Text("Okay"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: PColor.backgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bac.png"),
                        fit: BoxFit.fill)),
                child: Container(
                  padding: EdgeInsets.only(top: 90, left: 20),
                  color: Color(0xFF2BA0CE).withOpacity(.60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Welcome to",
                            style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 2,
                              color: Colors.yellow[700],
                            ),
                            children: [
                              TextSpan(
                                text: isSignupScreen ? " My Shop," : " Back,",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow[700],
                                ),
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        isSignupScreen
                            ? "Sign Up to Continue"
                            : "Sign In to Continue",
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            buildBottomHalfContainer(true),
            //Main Contianer for Login and Signup
            AnimatedPositioned(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              top: isSignupScreen ? 200 : 230,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 700),
                curve: Curves.bounceInOut,
                height: isSignupScreen ? 350 : 250,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignupScreen
                                          ? PColor.activeColor
                                          : PColor.textColor1),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "SIGNUP",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? PColor.activeColor
                                          : PColor.textColor1),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                              ],
                            ),
                          )
                        ],
                      ),

                      //for sign in and up
                      Container(
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    key: ValueKey('email'),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: PColor.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: PColor.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: PColor.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: 'please enter your email...',
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                          fontSize: 18,
                                          color: PColor.activeColor),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: PColor.textColor1),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Invalid email!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['email'] = value;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    key: ValueKey('password'),
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: hidePassword
                                            ? Icon(Icons.visibility)
                                            : Icon(Icons.visibility_off),
                                        color: PColor.primaryColor,
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        MaterialCommunityIcons.lock_outline,
                                        color: PColor.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: PColor.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: PColor.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                          fontSize: 18,
                                          color: PColor.activeColor),
                                      hintText: 'please enter your password...',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: PColor.textColor1),
                                    ),
                                    obscureText: hidePassword,
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 7) {
                                        return 'Password is too short!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['password'] = value;
                                    },
                                  ),
                                ),
                                if (isSignupScreen)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      enabled: isSignupScreen,
                                      key: ValueKey('confirmPassword'),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: hidePassword
                                              ? Icon(Icons.visibility)
                                              : Icon(Icons.visibility_off),
                                          color: PColor.primaryColor,
                                          onPressed: () {
                                            setState(() {
                                              hidePassword = !hidePassword;
                                            });
                                          },
                                        ),
                                        prefixIcon: Icon(
                                          MaterialCommunityIcons.lock_outline,
                                          color: PColor.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: PColor.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: PColor.textColor1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35.0)),
                                        ),
                                        contentPadding: EdgeInsets.all(10),
                                        labelText: 'Confirm Password',
                                        labelStyle: TextStyle(
                                            fontSize: 18,
                                            color: PColor.activeColor),
                                        hintText:
                                            'please confirm your password...',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: PColor.textColor1),
                                      ),
                                      obscureText: hidePassword,
                                      validator: (value) {
                                        if (value != _passwordController.text) {
                                          return 'Password isn\'t matched';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                if (!isSignupScreen)
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: isRememberMe,
                                              activeColor: PColor.textColor2,
                                              onChanged: (value) {
                                                setState(() {
                                                  isRememberMe = !isRememberMe;
                                                });
                                              },
                                            ),
                                            Text("Remember me",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: PColor.textColor1))
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text("Forgot Password?",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: PColor.textColor1)),
                                        )
                                      ],
                                    ),
                                  ),
                                if (isSignupScreen)
                                  Container(
                                    width: 200,
                                    margin: EdgeInsets.only(top: 20),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text:
                                              "By pressing 'Submit' you agree to our ",
                                          style: TextStyle(
                                              color: PColor.textColor2),
                                          children: [
                                            TextSpan(
                                              //recognizer: ,
                                              text: "term & conditions",
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                          ]),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Trick to add the submit button
            buildBottomHalfContainer(false),
            // Bottom buttons
            Positioned(
              top: MediaQuery.of(context).size.height - 100,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Text(isSignupScreen ? "Or SignUp with" : "Or SignIn with"),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildTextButton(MaterialCommunityIcons.facebook,
                            "Facebook", PColor.facebookColor),
                        buildTextButton(MaterialCommunityIcons.google_plus,
                            "Google", PColor.googleColor),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 500 : 430,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [PColor.primaryColor, PColor.primaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1))
                      ]),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          onPressed: submit,
                        ),
                )
              : Center(),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp_3/Model/CompleteProfile.dart';
import 'package:myapp_3/Model/Login.dart';

String? validateEmail(String? value) {
  var pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}

String? validatePassword(String value) {
  RegExp regex =
      RegExp(r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\$&*~]).{8,}$');
  if (value.isEmpty) {
    return 'Please enter password';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Enter valid password';
    } else {
      return null;
    }
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Center(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      splashRadius: 20,
                    ),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Image.asset(
                "assets/images/signup.png",
                height: 200,
                width: 280,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameTextController,
                        decoration: InputDecoration(
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Enter Username ",
                          labelText: " User Name ",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "User name can not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: validateEmail,
                        controller: _emailTextController,
                        decoration: InputDecoration(
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Enter Email",
                          labelText: "Email",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordTextController,
                        validator: (PassCurrentValue) {
                          RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                          var passNonNullValue = PassCurrentValue ?? "";
                          if (passNonNullValue.isEmpty) {
                            return ("Password is required");
                          } else if (passNonNullValue.length < 6) {
                            return ("Password Must be more than 5 characters");
                          } else if (!regex.hasMatch(passNonNullValue)) {
                            return ("Password should contain upper,lower,digit and Special character ");
                          }
                          return null;
                        },
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Icon(Icons.password),
                          hintText: "Enter Password",
                          labelText: "Password",
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              splashRadius: 25,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 400,
                height: 60,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text('SIGN UP'),
                  onPressed: () {
                    if (_nameTextController.text.isEmpty ||
                        _emailTextController.text.isEmpty ||
                        _passwordTextController.text.isEmpty) {
                      log('Empty Field');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Please fill all the details to Continue",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    } else {
                      log('Field Not Empty');
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(_emailTextController.text)
                          .set({
                        'email': _emailTextController.text,
                        'image': "",
                        'name': _nameTextController.text,
                        'number': "",
                        'subtitle': "",
                        'time': "",
                        'password': _passwordTextController.text,
                      }).then((value) {
                        log('Sign up succesfully');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.blue,
                            content: Text(
                              "Congratulation, your account has been successfully created.",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CompleteProfile(
                              myEmail: '',
                            ),
                          ),
                        );
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue to Sign Up.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

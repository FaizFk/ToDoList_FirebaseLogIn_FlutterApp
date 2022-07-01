import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_firebase/providers/auth.dart';

import 'home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  String email;
  VerifyEmailScreen({this.email = ''});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool isLoading = false;
  @override
  void initState() {
    print('ENtered Verifyscreen');
    FirebaseAuth auth = FirebaseAuth.instance;
    isEmailVerified = auth.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationLink();
    } else {
      setInMemory();
    }
    super.initState();
  }

  void setInMemory() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    Provider.of<AuthProvider>(context, listen: false)
        .setToken(await user!.getIdToken(), user.email ?? 'Nil');
    Navigator.pushNamed(context, HomeScreen.id);
  }

  Future sendVerificationLink() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.currentUser!.sendEmailVerification();
  }

  Future checkEmailVerification() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.currentUser!.reload();
      isEmailVerified = auth.currentUser!.emailVerified;
      if (isEmailVerified) {
        setInMemory();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Builder(builder: (_) {
            if (isEmailVerified) {
              Future.delayed(Duration.zero, () {
                Navigator.pushNamed(context, HomeScreen.id);
              });
              return Container();
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                            'A link is sent to your Email address ${widget.email}. Click on link to verify your account(Also Check the spam folder).Then click on Refresh button below...'),
                        alignment: Alignment.center,
                      ),
                      const SizedBox(
                        height: 10,
                        width: double.infinity,
                      ),
                      MaterialButton(
                          child: const Text(
                            'Refresh',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await checkEmailVerification();
                            setState(() {
                              isLoading = false;
                            });
                            if (isEmailVerified) {
                              Navigator.pushNamed(context, HomeScreen.id);
                            }
                          })
                    ],
                  ),
                ),
              );
            }
          });
  }
}

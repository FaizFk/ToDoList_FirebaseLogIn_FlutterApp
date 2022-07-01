import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_firebase/screens/verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String id = '/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  TextEditingController textController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      auth.signOut();
      print('Signedout one user');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late String email = '';
    late String password = '';
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      body: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login to continue',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: textController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RawMaterialButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          'Login/Signup',
                          style: TextStyle(color: Colors.white),
                        ),
                        fillColor: Colors.blue,
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await moveToHomeScreen(textController.text,
                              passwordController.text, context);
                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ],
                  ),
                )),
    );
  }
}

Future moveToHomeScreen(email, password, context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  if (email != '' && password != '') {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyEmailScreen(email: email))));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmailScreen(email: email)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${e.code}',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ));
      }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Please Enter Something",
        textAlign: TextAlign.center,
      ),
    ));
  }
}

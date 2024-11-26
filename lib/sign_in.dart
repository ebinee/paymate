import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paymate/main.dart';
import 'package:paymate/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF2E8DA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Image.asset(
                  'assets/images/paymate_logo.png',
                  width: 276,
                  height: 90,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white54,
                    labelText: "이메일",
                    labelStyle: const TextStyle(
                      color: Color(0xFF646464),
                    ),
                    hintText: "이메일을 입력해주세요",
                    hintStyle: const TextStyle(
                      color: Color(0xFF646464),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                  ),
                  controller: _emailController,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white54,
                    labelText: "비밀번호",
                    labelStyle: const TextStyle(
                      color: Color(0xFF646464),
                    ),
                    hintText: "비밀번호를 입력해주세요",
                    hintStyle: const TextStyle(
                      color: Color(0xFF646464),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                  ),
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text.toString();
                    String password = _passwordController.text.toString();

                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const App()),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('?꾩씠???먮뒗 鍮꾨?踰덊샇媛 ?쇱튂?섏? ?딆뒿?덈떎.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF646464),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: const Size(350, 50),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  child: const Text("로그인"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF646464),
                  ),
                  child: const Text("회원가입"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

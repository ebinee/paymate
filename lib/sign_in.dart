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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        titleSpacing: -10.0,
        title: const Text("로그인",
            style: TextStyle(
              color: Color(0xFF646464),
              fontSize: 15,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "이메일",
                  hintText: "이메일을 입력하세요",
                ),
                controller: _emailController,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "비밀번호",
                  hintText: "비밀번호를 입력하세요",
                ),
                controller: _passwordController,
              ),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.toString();
                  String password = _passwordController.text.toString();

                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
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
                        content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                      ),
                    );
                  }
                },
                child: const Text('로그인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

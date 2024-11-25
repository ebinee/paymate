import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const Header(
        headerTitle: '회원가입',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "이름",
                          hintText: "이름을 입력하세요",
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "이름을 입력해주세요.";
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      TextFormField(
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "이메일",
                          hintText: "이메일을 입력하세요",
                        ),
                        controller: _emailController,
                        validator: (value) => CheckValidate()
                            .validateEmail(_idFocus, value ?? ''),
                        onSaved: (value) {},
                      ),
                      TextFormField(
                        focusNode: _idFocus,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "아이디",
                          hintText: "아이디를 입력하세요",
                        ),
                        controller: _userIdController,
                        validator: (value) =>
                            CheckValidate().validateId(_idFocus, value ?? ''),
                        onSaved: (value) {},
                      ),
                      TextFormField(
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "비밀번호",
                          hintText: "비밀번호를 입력하세요",
                        ),
                        controller: _passwordController,
                        validator: (value) => CheckValidate()
                            .validatePassword(_passwordFocus, value ?? ''),
                        onSaved: (value) {},
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "비밀번호 확인",
                          hintText: "비밀번호를 한 번 더 입력하세요",
                        ),
                        controller: _passwordConfirmController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 한 번 더 입력해주세요';
                          } else if (value !=
                              _passwordController.text.toString()) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ],
                  )),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  String userid = _userIdController.text.toString();
                  String email = _emailController.text.toString();
                  String username = _nameController.text.toString();
                  String password = _passwordController.text.toString();
                  String passwordConfirm =
                      _passwordConfirmController.text.toString();

                  Account newAccount = Account(
                    id: userid,
                    email: email,
                    username: username,
                    password: password,
                    passwordConfirm: passwordConfirm,
                  );

                  if (password != passwordConfirm) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('비밀번호가 일치하지 않습니다.'),
                      ),
                    );
                    return;
                  }

                  if (!newAccount.isEmpty()) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: newAccount.email,
                        password: newAccount.password,
                      );

                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      await firestore
                          .collection("user")
                          .doc(newAccount.email)
                          .set({
                        "email": newAccount.email,
                        "id": newAccount.id,
                        "name": newAccount.username,
                      });
                      FirebaseAuth.instance.signOut();

                      if (!mounted) return;
                      Navigator.pop(context);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('이미 사용 중인 이메일입니다.'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('알 수 없는 오류: $e'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('가입하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckValidate {
  String? validateId(FocusNode focusNode, String value) {
    final idRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (value.isEmpty) {
      return "아이디를 입력해주세요";
    } else if (value.length < 4 || value.length > 20) {
      focusNode.requestFocus();
      return "아이디는 4자 이상, 20자 이하로 입력해주세요";
    } else if (!idRegex.hasMatch(value)) {
      focusNode.requestFocus();
      return "아이디는 영문, 숫자, 밑줄(_)만 사용할 수 있습니다";
    }
    return null;
  }

  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      return "비밀번호를 입력해주세요";
    } else if (value.length < 8) {
      focusNode.requestFocus();
      return '비밀번호는 최소 8자 이상이어야 합니다';
    } else if (!RegExp(r'[0-9]').hasMatch(value) ||
        !RegExp(r'[!@#$%^&*(),.:{}|<>]').hasMatch(value)) {
      focusNode.requestFocus();
      return "비밀번호는 숫자와 특수문자를 포함해야 합니다";
    }
    return null;
  }

  String? validateEmail(FocusNode focusNode, String value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value.isEmpty) {
      return "이메일을 입력해주세요";
    } else if (!emailRegex.hasMatch(value)) {
      focusNode.requestFocus();
      return "유효한 이메일 형식을 입력해주세요";
    }
    return null;
  }
}

class Account {
  final String id;
  final String username;
  final String password;
  final String passwordConfirm;
  final String email;

  Account({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.passwordConfirm,
  });

  bool isEmpty() {
    return email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        passwordConfirm.isEmpty ||
        email.isEmpty;
  }
}

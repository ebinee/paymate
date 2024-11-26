import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: SizedBox(
            width: 20,
            height: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/paymate_logo.png',
                  width: 200,
                  height: 65,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "회원가입",
                  style: TextStyle(
                      color: Color(0xFF646464),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "이름",
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 290,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "이름",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color(0xFFF2E8DA).withOpacity(0.6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 15),
                                ),
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "이름을 입력해주세요";
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "이메일",
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: 290,
                                child: Flexible(
                                  child: TextFormField(
                                    focusNode: _emailFocus,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: "이메일",
                                      hintStyle: const TextStyle(
                                        color: Color(0xFFB0B0B0),
                                        fontWeight: FontWeight.w200,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF2E8DA)
                                          .withOpacity(0.6),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 15),
                                    ),
                                    controller: _emailController,
                                    validator: (value) => CheckValidate()
                                        .validateEmail(_idFocus, value ?? ''),
                                    onSaved: (value) {},
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "아이디",
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 290,
                              child: TextFormField(
                                focusNode: _idFocus,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "아이디",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontWeight: FontWeight.w200,
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color(0xFFF2E8DA).withOpacity(0.6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 15),
                                ),
                                controller: _userIdController,
                                validator: (value) => CheckValidate()
                                    .validateId(_idFocus, value ?? ''),
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "비밀번호",
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 290,
                              child: TextFormField(
                                focusNode: _passwordFocus,
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "비밀번호",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontWeight: FontWeight.w200,
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color(0xFFF2E8DA).withOpacity(0.6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 15),
                                ),
                                controller: _passwordController,
                                validator: (value) => CheckValidate()
                                    .validatePassword(
                                        _passwordFocus, value ?? ''),
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 290,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "비밀번호 재입력",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontWeight: FontWeight.w200,
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color(0xFFF2E8DA).withOpacity(0.6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 15),
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
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
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

                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
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
                  child: const Text('가입하기'),
                )
              ],
            ),
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
      return '비밀번호는 숫자와 특수문자를 포함해야 합니다';
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

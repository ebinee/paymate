import 'package:flutter/material.dart';
import 'package:paymate/financial_ledger.dart';
import 'package:paymate/friend_list.dart';
import 'package:paymate/group_list.dart';
import 'package:paymate/header.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: App(),
    ),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _Appstate();
}

class NewPage extends StatelessWidget {
  final String id;
  final String name;

  const NewPage({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        headerTitle: "내 정보",
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.person_pin, size: 300, color: Colors.pinkAccent),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 5),
            Text('ID : $id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // 클리퍼 재사용 여부
  }
}

class _Appstate extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TrapezoidClipper(),
          child: Container(
            width: double.infinity,
            height: 230, // 높이 조정 가능
            color: const Color(0xFFF2E8DA),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/paymate_logo.png',
                    width: 200,
                    height: 65,
                    fit: BoxFit.fill,
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToNewPage(context);
                    },
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF646464),
                      size: 45,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FinancialLedger()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 25), // 패딩
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 모서리 둥글기
                      ),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          'MY \n가계부',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Icon(
                              Icons.arrow_forward_ios, // 화살표 아이콘
                              size: 20,
                              color: Color(0xFFFFB2A5),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendList()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white.withOpacity(0.9), // 텍스트 색상
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 25), // 패딩
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 모서리 둥글기
                      ),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          'MY \n친구목록',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Icon(
                              Icons.arrow_forward_ios, // 화살표 아이콘
                              size: 20,
                              color: Color(0xFFFFB2A5),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GroupList()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black54,
                  backgroundColor: const Color(0xFFFFB2A5).withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0, vertical: 0), // 패딩
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 모서리 둥글기
                  ),
                  maximumSize: const Size(330, 130),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'MY \n모임목록',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Icon(
                      Icons.group_outlined, // 사람 모양 아이콘
                      size: 130,
                      color: Colors.white70,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 85,
                        ),
                        Icon(
                          Icons.arrow_forward_ios, // 화살표 아이콘
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(left: 25.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                  children: [
                    Text(
                      "MONTHLY 지출",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  void _navigateToNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const NewPage(id: "USER", name: "사용자")),
    );
  }
}

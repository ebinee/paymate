import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:paymate/financial_ledger.dart';
import 'package:paymate/friend_list.dart';
import 'package:paymate/group_list.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white, // 사다리꼴 바깥 영역의 배경색
      body: App(),
    ),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _Appstate();
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); // 왼쪽 위
    path.lineTo(size.width, 0); // 오른쪽 위
    path.lineTo(size.width, size.height - 40); // 오른쪽 아래
    path.lineTo(0, size.height); // 왼쪽 아래
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
            child: Column(
              children: [
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
                    const Icon(
                      Icons.person,
                      color: Color(0xFF646464),
                      size: 45,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
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
                        backgroundColor:
                            Colors.white.withOpacity(0.9), // 텍스트 색상
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
                  height: 30,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 수평 정렬을 왼쪽으로
                    children: [
                      const Row(
                        children: [
                          SizedBox(width: 30), // 왼쪽 여백
                          Text(
                            'MONTHLY 지출',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 300, // 충분한 크기 지정
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 200, // 막대의 최대 y 값 설정
                                barTouchData: BarTouchData(enabled: false),
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTextStyles: (context, value) =>
                                        const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    getTitles: (value) {
                                      return value.toStringAsFixed(0); // y축 값
                                    },
                                  ),
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTitles: (value) {
                                      return value.toStringAsFixed(0); // x축 값
                                    },
                                    getTextStyles: (context, value) =>
                                        const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                barGroups: [
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(
                                        y: 120, // 첫 번째 막대의 높이
                                        colors: [Colors.blue],
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(
                                        y: 100, // 두 번째 막대의 높이
                                        colors: [Colors.red],
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(
                                        y: 180, // 세 번째 막대의 높이
                                        colors: [Colors.green],
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 3,
                                    barRods: [
                                      BarChartRodData(
                                        y: 120, // 네 번째 막대의 높이
                                        colors: [Colors.orange],
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 4,
                                    barRods: [
                                      BarChartRodData(
                                        y: 90, // 다섯 번째 막대의 높이
                                        colors: [Colors.purple],
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 5,
                                    barRods: [
                                      BarChartRodData(
                                        y: 160, // 여섯 번째 막대의 높이
                                        colors: [Colors.yellow],
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

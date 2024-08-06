// import 'package:flutter/material.dart';
// //import 'package:paymate/main.dart';
// //import 'package:paymate/add_schedule.dart';

// class GroupList extends StatefulWidget {
//   const GroupList({super.key});

//   @override
//   State<GroupList> createState() => GroupListState();
// }

// class GroupListState extends State<GroupList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(50.0), // 원하는 높이로 설정 (단위: 픽셀)
//         child: AppBar(
//           backgroundColor: const Color(0xFFF2E8DA),
//           elevation: 0,
//           title: const Text(
//             '모임 목록',
//             style: TextStyle(color: Color(0xFF646464)),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_rounded,
//                 color: Color(0xFF646464)),
//             onPressed: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const App()));
//             },
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // 새로운 모임 추가 기능
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddSchedule()), // 원하는 화면으로 전환
//                 );
//               },
//               child: Container(
//                 height: 80,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: const Color(0xFFFFB2A5)),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Center(
//                   child: IconButton(
//                     icon: Icon(Icons.add, color: Color(0xFF646464)),
//                     onPressed: null,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView(
//                 children: [
//                   GroupCard(
//                     title: '엽떡팟',
//                     date: '07/22',
//                     members: '컴공 23 이수현, 인지 23 박우진',
//                     backgroundColor: const Color(0xFFFFB2A5).withOpacity(0.2),
//                     borderColor: const Color(0xFFFFB2A5).withOpacity(0.2),
//                     imageAssetPath: 'assets/images/iceBear.jpg',
//                   ),
//                   GroupCard(
//                     title: '갓생스터디',
//                     date: '07/22',
//                     members: '한현비, 김예빈, 이수현',
//                     backgroundColor: const Color(0xFFFFB2A5).withOpacity(0.2),
//                     borderColor: const Color(0xFFFFB2A5).withOpacity(0.2),
//                     imageAssetPath: 'assets/images/pinkBear.jpg',
//                   ),
//                   const GroupCard(
//                     title: '계절총회',
//                     date: '06/09',
//                     members: '컴공 23 강지현, 컴공 23 김효정',
//                     backgroundColor: Color(0xFFB0B0B0),
//                     imageAssetPath: 'assets/images/jin.jpg',
//                   ),
//                   const GroupCard(
//                     title: '중간총회',
//                     date: '06/02',
//                     members: '하성준, 박찬종',
//                     backgroundColor: Color(0xFFB0B0B0),
//                     imageAssetPath: 'assets/images/sky.jpg',
//                   ),
//                   const GroupCard(
//                     title: '번개모임',
//                     date: '05/19',
//                     members: '김해나, 이유진',
//                     backgroundColor: Color(0xFFB0B0B0),
//                     imageAssetPath: 'assets/images/soom.jpg',
//                   ),
//                   const GroupCard(
//                     title: '주제연구',
//                     date: '05/09',
//                     members: '팀원 1, 팀원 2',
//                     backgroundColor: Color(0xFFB0B0B0),
//                     imageAssetPath: 'assets/images/blue.jpg',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GroupCard extends StatelessWidget {
//   final String title;
//   final String date;
//   final String members;
//   final Color? backgroundColor;
//   final Color? borderColor;
//   final String imageAssetPath;

//   const GroupCard({
//     super.key,
//     required this.title,
//     required this.date,
//     required this.members,
//     this.backgroundColor,
//     this.borderColor,
//     required this.imageAssetPath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor ?? Colors.white,
//         border: Border.all(
//           color: borderColor ?? Colors.transparent,
//           width: 1.0,
//           style: BorderStyle.solid,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         /*boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],*/
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: AssetImage(imageAssetPath), // 그룹 이미지
//             radius: 24,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   members,
//                   style: TextStyle(color: Colors.black.withOpacity(0.6)),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             date,
//             style: TextStyle(color: Colors.black.withOpacity(0.6)),
//           ),
//         ],
//       ),
//     );
//   }
// }

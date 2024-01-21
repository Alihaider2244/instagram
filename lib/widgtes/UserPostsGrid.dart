// import 'package:flutter_svg/svg.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:instagram_clone/Utils/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:instagram_clone/Models/PostModel.dart';
// import 'package:instagram_clone/screens/PostScreen.dart';
// import 'package:instagram_clone/screens/ProfileScreen.dart';
// import 'package:instagram_clone/Provider/UserProvider.dart';
// import 'package:instagram_clone/Models/userModel.dart' as model;

// class ProfileGridPosts extends StatelessWidget {
//   const ProfileGridPosts({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     model.UserModel? user = Provider.of<UserProvider>(context).getUser;

//     if (user == null || user.uid == null || user.uid.isEmpty) {
//       return const Scaffold(
//         body: Center(
//           child: Text('User not authenticated or UID is missing.'),
//         ),
//       );
//     }

//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Posts')
//             .doc(user.uid)
//             .collection('allposts')
//             .snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: primaryColor),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text('No posts available for the current user.'),
//             );
//           }

//           return GridView.builder(
//             gridDelegate:
//                 SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               // Map<String, dynamic> postData = snapshot.data!.docs[index].data();
//               Future.delayed(Duration.zero, () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ProfileScreen(snap: snapshot.data!.docs[index].data()),
//                   ),
//                 );
//               });
//               return Image.network(snapshot.data!.docs[index]['photoURL']);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

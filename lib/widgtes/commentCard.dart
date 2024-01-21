import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentCard extends StatelessWidget {
  final snap;
  
   CommentCard({super.key, this.snap});
int _length=2;
  @override
  Widget build(BuildContext context) {
    print('snapj');
    print(snap.length);
    return  snap.length==_length? Center(child: Text('empty',style: TextStyle(color: primaryColor),),): Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20, // Adjust the radius as needed
          backgroundImage: NetworkImage(
            snap['dp'],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: snap['name'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: ' ${snap['text']}',
                      style: TextStyle(fontWeight: FontWeight.w500))
                ]),
              ),
              Text(
                DateFormat.yMMMd().format(
                  (snap['date'] as Timestamp).toDate(),
                ),
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
      ],
    );
  }
}

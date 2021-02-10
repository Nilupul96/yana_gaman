import 'package:flutter/material.dart';
import 'package:yana_gaman/models/comments.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comments> _commentList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[700],
        title: Text("Comments"),
      ),
      body: Stack(
        children: [
          Container(alignment: Alignment.bottomCenter, child: _addCommentTile())
        ],
      ),
    );
  }

  Widget _addCommentTile() {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 50.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            decoration: BoxDecoration(
                color: Colors.lightGreen[200],
                borderRadius: BorderRadius.circular(6.0)),
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  suffixIcon: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
        Container(
            width: 30.0,
            margin: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.send, color: Colors.lightGreen[700]))
      ],
    );
  }

  // Widget _commentListview() {
  //   if (_commentList.length > 0 && _commentList != null) {
  //     return ListView.builder(itemBuilder: (context, int index) {
  //       return _commentListTile();
  //     });
  //   } else {
  //     Text(
  //       "No comments",
  //       style: HintTextStyle_2,
  //     );
  //   }
  // }

  // Widget _commentListTile(String text) {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           CircleAvatar(
  //             radius: 15.0,
  //             backgroundColor: Colors.grey[200],
  //             backgroundImage: (!isNameLoading && profPic != null)
  //                 ? NetworkImage(profPic)
  //                 : AssetImage('assets/images/prof.png'),
  //           ),
  //           SizedBox(
  //             width: 10.0,
  //           ),
  //           Text(
  //             !isNameLoading ? name : "",
  //             textAlign: TextAlign.left,
  //             style: TextStyle(
  //                 fontSize: 13.0,
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.w700),
  //           )
  //         ],
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(bottom: 8.0, left: 10.0),
  //         padding: EdgeInsets.all(5.0),
  //         decoration: BoxDecoration(
  //             color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
  //         child: Text(text),
  //       ),
  //     ],
  //   );
  // }
}

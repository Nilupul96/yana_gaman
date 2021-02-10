import 'package:flutter/material.dart';
import 'package:yana_gaman/ui/screens/addPost_screen.dart';
import 'package:yana_gaman/ui/screens/diary_screen.dart';
import 'package:yana_gaman/ui/screens/home_screen.dart';

class Home extends StatefulWidget {
  final int initialIndex;
  Home({this.initialIndex});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentindex = 0;
  @override
  void initState() {
    super.initState();
    _currentindex = widget.initialIndex;
  }

  //page caller in the app
  List<Widget> _children = [
    HomePage(),
    AddPost(),
    Diary(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightGreen[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Diary',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}

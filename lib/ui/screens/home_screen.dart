import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:yana_gaman/ui/screens/addPost_screen.dart';
import 'package:yana_gaman/ui/screens/postDetails_screen.dart';
import 'package:yana_gaman/ui/screens/search_screen.dart';
import 'package:yana_gaman/ui/widgets/post_list_item.dart';
import 'package:yana_gaman/ui/widgets/profilePicture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yana_gaman/models/post.dart';
import 'package:yana_gaman/ui/widgets/progressView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String profilePic;
  List<Post> _postList = [];
  Post post;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    QuerySnapshot snapAll =
        await FirebaseFirestore.instance.collection("Users").get();
    _postList.clear();
    snapAll.docs.forEach((element) async {
      print(element.id);
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(element.id)
          .collection("Posts")
          .get();
      snap.docs.forEach((document) {
        post = Post(
            title: document.data()["title"],
            description: document.data()["discription"],
            name: document.data()["name"],
            images: document.data()["images"],
            userId: document.data()["userId"],
            id: document.id,
            rating: document.data()["rating"].toDouble());

        _postList.add(post);
        print(_postList.length);
        print(document.id);
      });
      setState(() {
        _isLoading = false;
        print("length" + _postList.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageSliderCaroUsel = Container(
        height: 300,
        child: Carousel(
          images: [
            AssetImage('assets/images/img1.jpg'),
            AssetImage('assets/images/img2.jpg'),
            AssetImage('assets/images/img3.jpg'),
          ],
          indicatorBgPadding: 2.0,
        ));
    return Scaffold(
      //Appbar
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Home"),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchScreen())),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            ),
            ProfilePicture(),
          ],
          backgroundColor: Colors.lightGreen[700]),

      //floating Action Button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        backgroundColor: Colors.lightGreen[800],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
      ),
      //image slide Show
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
            child: Text(
              "Trending palces in this week",
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          imageSliderCaroUsel,
          SizedBox(
            height: 15.0,
          ),
          !_isLoading
              ? postFeed()
              : ProgressView(
                  small: true,
                )
        ],
      ),
    );
  }

  Widget postFeed() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: _postList.length,
        itemBuilder: (buildContext, index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostDetailsScreen(
                      title: _postList[index].title,
                      discrip: _postList[index].description,
                      rating: _postList[index].rating.toDouble(),
                      imageList: _postList[index].images,
                      userId: _postList[index].userId,
                    ))),
            child: PostLitTile(
              title: _postList[index].title,
              description: _postList[index].description,
              rating: _postList[index].rating.toDouble(),
              imageList: _postList[index].images,
              userId: _postList[index].userId,
            ),
          );
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/rating/gf_rating.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yana_gaman/home.dart';
import 'package:yana_gaman/styles.dart';
import 'package:yana_gaman/ui/widgets/button.dart';
import 'package:yana_gaman/ui/widgets/progressView.dart';

class PostDetailsScreen extends StatefulWidget {
  final String userId;
  final int id;
  final String title;
  final String discrip;
  final double rating;
  final String name;
  final double lat;
  final double long;
  final List<dynamic> imageList;
  final String profPic;
  PostDetailsScreen(
      {this.id,
      this.userId,
      this.discrip,
      this.lat,
      this.long,
      this.name,
      this.rating,
      this.imageList,
      this.profPic,
      this.title});
  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  String name = "Nilupul";
  String title = "Bopath Falls";
  double _rating = 0.0;
  bool mapToogle = true;
  bool isLoad = false;
  var _currentLocation;
  GoogleMapController mapController;
  List<Marker> _markerList = [];
  String profPic;
  bool isNameLoading = true;
  void _onMapCreated(controler) {
    mapController = controler;
  }

  @override
  void initState() {
    super.initState();
    getProfileDetailes();
    // Geolocator().getCurrentPosition().then((value) {
    //   setState(() {
    //     _currentLocation = value;
    //     mapToogle = true;
    //   });
    // });
    _markerList.add(_marker("6.8000", "80.3667", "1", "Bopath falls"));
  }

  getProfileDetailes() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userId)
        .get();
    name = snapshot.data()["name"];
    profPic = snapshot.data()["profilePic"];
    setState(() {
      isNameLoading = false;
    });
    print(name);
    print(profPic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.lightGreen[700],
        title: Text("Post Details"),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [BoxShadow(color: ShadowColor, blurRadius: 6.0)]),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: (profPic != null && !isNameLoading)
                      ? NetworkImage(profPic)
                      : AssetImage('assets/images/pro.png'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  !isNameLoading ? name : "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                widget.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                widget.discrip,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black.withOpacity(0.3),
                    fontWeight: FontWeight.w500),
              ),
            ),
            _imageList(),
            SizedBox(
              height: 10.0,
            ),
            _getMap(),
            SizedBox(
              height: 10.0,
            ),
            _starRating(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.message_outlined,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Add Comments",
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home(initialIndex: 2,))),
              child: Button(
                buttonName: "Add to diary",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.imageList.length,
        itemBuilder: (context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 200.0,
              child: Image.network(
                widget.imageList[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        });
  }

  Widget _getMap() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 268.0,
        child: mapToogle
            ? GoogleMap(
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: LatLng(6.8000, 80.3667), zoom: 15),
                mapType: MapType.normal,
                markers: Set.of(_markerList),
              )
            : Container(child: Center(child: ProgressView(small: true))));
  }

  Widget _starRating() {
    return Container(
      alignment: Alignment.centerLeft,
      // padding: EdgeInsets.only(left: 20.0),
      child: GFRating(
        defaultIcon: Icon(Icons.star, color: Color(0xffd3d4d2), size: 40.0),
        spacing: 6.0,
        filledIcon: Icon(Icons.star, color: GoldColor, size: 40.0),
        value: _rating,
        onChanged: (rating) {
          setState(() {
            _rating = rating;
          });
        },
      ),
    );
  }

  Marker _marker(String lat, String long, String id, String name) {
    return Marker(
        markerId: MarkerId(id),
        position: LatLng(double.parse(lat), double.parse(long)),
        infoWindow: InfoWindow(title: name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan));
  }
}

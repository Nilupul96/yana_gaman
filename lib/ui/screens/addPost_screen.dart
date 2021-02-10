import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yana_gaman/ui/widgets/button.dart';
import 'package:yana_gaman/ui/widgets/profilePicture.dart';
import 'package:yana_gaman/ui/widgets/progressDialog.dart';
import 'package:yana_gaman/ui/widgets/progressView.dart';
import 'package:yana_gaman/ui/widgets/textfield.dart';
import 'package:yana_gaman/utils/alerts.dart';
import 'package:yana_gaman/utils/firebase.dart';

import '../../home.dart';
import '../../styles.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _title = TextEditingController();
  TextEditingController _details = TextEditingController();
  GoogleMapController mapController;
  List<Marker> _markerList = [];
  List<Asset> images = List<Asset>();
  List<File> files = List<File>();
  List<String> imageList = [];
  File file;
  Asset asset;
  String name;
  bool mapToogle = true;
  void _onMapCreated(controler) {
    mapController = controler;
  }

  ProgressDlg _progressDig;

  @override
  void initState() {
    super.initState();
    // Geolocator().getCurrentPosition().then((value) {
    //   setState(() {
    //     //  _currentLocation = value;
    //     print("value" + value.toString());
    //     mapToogle = true;
    //   });
    // });
    _markerList.add(_marker("6.8000", "80.3667", "1", "Bopath falls"));
  }

  Future<bool> addImagesTofirebase() async {
    if (files != null) {
      for (var i = 0; i < files.length; i++) {
        var ref = FirebaseStorage.instance
            .ref()
            .child(FirebaseAuth.instance.currentUser.uid)
            .child(_title.text.trim());
        await ref.putFile(files[i]).whenComplete(() async {
          String url = await ref.getDownloadURL();
          imageList.add(url);
          print("download url: $url");
          return true;
        }).catchError((onError) {
          print(onError);
          return false;
        });
      }
    }
    return true;
  }

  addPost() {
    _progressDig = ProgressDlg(context);
    _progressDig.show();

    // Timer(Duration(seconds: 3), () {
    //   _progressDig.hide();
    //   Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => Home()));
    // });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#007C85",
          actionBarTitle: "Yana Gaman",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#007C85",
        ),
      );
    } on Exception catch (e) {
      String error = e.toString();
      print(error);
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      getFileList();
    });
  }

  void getFileList() async {
    files.clear();
    for (int i = 0; i < images.length; i++) {
      var path2 =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      file = await getImageFileFromAsset(path2);
      files.add(file);
    }
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.lightGreen[700],
        title: Text("Add Post"),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          ProfilePicture(),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Form(
              // key: _formKey,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                  ),
                  CustomTextField(
                    labelText: "Title",
                    labelStyle: HintTextStyle_1,
                    controller: _title,
                    keyboardType: TextInputType.text,
                  ),
                  CustomTextField(
                    labelText: "Description",
                    labelStyle: HintTextStyle_1,
                    controller: _details,
                    keyboardType: TextInputType.emailAddress,
                    minLine: 8,
                    maxLine: 10,
                  ),
                  Text(
                    "Add current location",
                    style: HintTextStyle_1,
                  ),
                  _getMap(),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildGridView(),
                  _outLineButton(),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () async {
                      _progressDig = ProgressDlg(context);
                      _progressDig.show();
                      var test = await addImagesTofirebase();

                      var verified = test
                          ? await addNewPost(
                              title: _title.text,
                              discription: _details.text,
                              imageList: imageList,
                              userId: FirebaseAuth.instance.currentUser.uid,
                              rating: 0.0)
                          : () {
                              print("object");
                            };
                      if (verified) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Home(
                                  initialIndex: 0,
                                )));
                      } else {
                        Alerts.showMessage(context, " message");
                      }

                      addPost();
                    },
                    child: Button(
                      buttonName: "Post",
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMap() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 208.0,
        child: mapToogle
            ? GoogleMap(
                zoomControlsEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: LatLng(6.8000, 80.3667), zoom: 15),
                mapType: MapType.normal,
                markers: Set.of(_markerList),
              )
            : Container(child: Center(child: ProgressView(small: true))));
  }

  Widget _outLineButton() {
    return GestureDetector(
      onTap: () => loadAssets(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15.0),
        height: 52.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [BoxShadow(color: ShadowColor, blurRadius: 6.0)]),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 19.5,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 17.5,
                  backgroundColor: DefaultColor,
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                    size: 22.0,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text("Add images", style: HintTextStyle_1)
            ],
          ),
        ),
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

  Widget buildGridView() {
    return (images != null && images.length > 0)
        ? Container(
            child: GridView.count(
              scrollDirection: Axis.vertical,
              mainAxisSpacing: 4.0,
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: List.generate(images.length, (index) {
                Asset asset = images[index];
                print(asset.identifier);
                return Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: AssetThumb(
                            asset: asset,
                            width: 115,
                            height: 80,
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 8.0,
                            child: InkWell(
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.red,
                              ),
                              onTap: () {
                                setState(() {
                                  images.remove(asset);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ));
              }),
            ),
          )
        : SizedBox();
  }
}

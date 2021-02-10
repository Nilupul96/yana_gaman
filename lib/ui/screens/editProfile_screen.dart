import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yana_gaman/styles.dart';
import 'package:yana_gaman/ui/screens/profile_screen.dart';
import 'package:yana_gaman/ui/widgets/button.dart';
import 'package:yana_gaman/ui/widgets/progressDialog.dart';
import 'package:yana_gaman/ui/widgets/progressView.dart';
import 'package:yana_gaman/ui/widgets/textfield.dart';
import 'package:yana_gaman/utils/alerts.dart';
import 'package:yana_gaman/utils/firebase.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String city;
  final String bio;
  final String proPic;
  EditProfileScreen({this.bio, this.city, this.name, this.email, this.proPic});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _bio = TextEditingController();
  ProgressDlg _progressDlg;
  String downloadurl;
  // DateTime _dob;
  // DateTime date;
  // var _listGender = ["Male", "Female"];
  // String _valGender;
  File _image;
  // String _valCountryCode;
  // var _countrycode = ["LK", "AU", "US", "IN"];
  String profPic;
  bool isLoad = false;
  final picker = ImagePicker();
  var jsonPosts;
  ProgressDlg _progressDig;
  static InputBorder enabledBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Color(0xffDFDFDF)));

  Future getImage() async {
    print("object");
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _firstName.text = widget.name;
    _email.text = widget.email;
    _city.text = widget.city;
    _bio.text = widget.bio;
    // getUser();
  }

  updateUser() {
    _progressDig = ProgressDlg(context);
    _progressDig.show();
    Timer(Duration(seconds: 3), () {
      _progressDig.hide();
      Navigator.of(context).pop();
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => ProfileScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.lightGreen[700],
        title: Text("Edit Profile"),
      ),
      backgroundColor: Colors.white,
      // bottomNavigationBar: BottomNavbar(),

      body: isLoad
          ? Center(child: ProgressView(small: true))
          : ListView(
              children: [
                Container(
                  height: 155.00,
                  child: Stack(
                    children: [
                      Positioned(
                          left: (MediaQuery.of(context).size.width - 115) / 2,
                          top: 26.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(72.5),
                            child: Container(
                              child: _image == null
                                  ? profPic != null
                                      ? Image.network(
                                          profPic,
                                          width: 115,
                                          height: 115,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          "assets/images/prof.png",
                                          width: 115,
                                          height: 115,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.file(_image,
                                      width: 115,
                                      height: 115,
                                      fit: BoxFit.cover),
                            ),
                          )),
                      Positioned(
                          right: (MediaQuery.of(context).size.width - 39) / 2,
                          //  right: 20.0,
                          top: 112.0,
                          child: GestureDetector(
                            onTap: () => getImage(),
                            child: CircleAvatar(
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
                          )),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                        ),
                        CustomTextField(
                          labelText: "Username",
                          labelStyle: HintTextStyle_1,
                          controller: _firstName,
                          keyboardType: TextInputType.text,
                        ),
                        CustomTextField(
                          labelText: "Email Address",
                          labelStyle: HintTextStyle_1,
                          controller: _email,
                          keyboardType: TextInputType.text,
                        ),
                        CustomTextField(
                          labelText: "Hometown",
                          labelStyle: HintTextStyle_1,
                          controller: _city,
                          keyboardType: TextInputType.multiline,
                        ),
                        CustomTextField(
                          labelText: "Bio",
                          labelStyle: HintTextStyle_1,
                          controller: _bio,
                          // keyboardType: TextInputType.text,
                          minLine: 8,
                          maxLine: 10,
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () async {
                            _progressDlg = ProgressDlg(context);
                            // _progressDig.show();
                            if (_image != null) {
                              var ref = FirebaseStorage.instance
                                  .ref()
                                  .child("profilePic")
                                  .child(FirebaseAuth.instance.currentUser.uid);
                              await ref.putFile(_image).whenComplete(() async {
                                downloadurl = await ref.getDownloadURL();

                                print("download url: $downloadurl");
                              }).catchError((onError) {
                                print(onError);
                              });
                            }

                            var verified = await updateProfile(
                                userName: _firstName.text,
                                email: _email.text,
                                city: _city.text,
                                profilePic: downloadurl,
                                bio: _bio.text);
                            // _progressDig.hide();
                            if (verified) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen()));
                            } else {
                              Alerts.showMessage(context, "Please try again");
                            }
                          },
                          child: Button(
                            buttonName: "Update",
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
}

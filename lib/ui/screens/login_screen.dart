import 'package:flutter/material.dart';
import 'package:yana_gaman/home.dart';
import 'package:yana_gaman/ui/screens/signup_screen.dart';
import 'package:yana_gaman/ui/widgets/button.dart';
import 'package:yana_gaman/ui/widgets/progressDialog.dart';
import 'package:yana_gaman/utils/alerts.dart';
import 'package:yana_gaman/utils/firebase.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPage();
  }
}

class LoginPage extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _isHidden = true;
  var _formKey = GlobalKey<FormState>();
  ProgressDlg _progressDlg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[700],
          automaticallyImplyLeading: true,
          title: Text("Log In"),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        height: 110.0,
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                            child: Image.asset("assets/images/logo1.png"))),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      //username textfield
                      child: TextFormField(
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) =>
                            value.isEmpty ? 'please enter email' : null,
                        decoration: InputDecoration(
                            labelText: "Email",
                            hintText: 'please enter your username',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),

                    // paasword text field
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        validator: (value) =>
                            value.isEmpty ? 'please enter password' : null,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Password",
                            hintText: 'please enter your Password',
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isHidden = !_isHidden;
                                  });
                                },
                                child: _isHidden
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),

                    //forgot password option
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: InkWell(
                          onTap: () {
                            //reset password
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          )),
                    ),

                    //call to login button
                    GestureDetector(
                        child: Button(
                          buttonName: "Log in",
                        ),
                        onTap: () async {
                          _progressDlg = ProgressDlg(context);
                          _progressDlg.show();
                          var verified = await logIn(
                              userNameController.text.toString(),
                              passwordController.text.toString(),
                              context);
                          // var user = FirebaseAuth.instance.currentUser.uid;
                          // Settings.setUserName(user);
                          _progressDlg.hide();
                          if (verified) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => Home(
                                          initialIndex: 0,
                                        )));
                            // var snapshot = await FirebaseFirestore.instance
                            //     .collection("Users")
                            //     .doc(FirebaseAuth.instance.currentUser.uid)
                            //     .get();
                            // if (snapshot.data()['email'] == null ||
                            //     snapshot.data()['city'] == null ||
                            //     snapshot.data()['profilePic'] == null) {
                            //   Navigator.of(context).pushReplacement(
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               EditProfileScreen()));
                            // } else {

                            // }
                          } else {
                            Alerts.showMessage(context, "Please Try Again!!!");
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "OR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await signInWithGoogle();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: SizedBox(
                        height: 57.0,
                        child: Container(
                          // margin: EdgeInsets.symmetric(horizontal: 26),
                          alignment: AlignmentDirectional.bottomStart,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/google_logo.png",
                                  width: 20.0,
                                  height: 20.0,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text('Continue with Google',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 57.0,
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 26),
                        alignment: AlignmentDirectional.bottomStart,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 40.0,
                                color: Colors.lightGreen[500],
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Log in as a Guest',
                                  style: TextStyle(
                                      color: Colors.lightGreen[500],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //signup text
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: 20.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New user?',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => SignUp())),
                            child: Text(
                              ' Sign up here ',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.blue,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}

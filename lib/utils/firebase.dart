import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> logIn(String email, String password, context) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return true;
  } catch (e) {
    print('wrong password');
    return false;
  }
}

Future<bool> register(
    String email, String password, context, String username) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await updateProfile(userName: username, email: email, city: "", bio: "");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
  final user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final String currentUserId = await FirebaseAuth.instance.currentUser.uid;
  assert(user.uid == currentUserId);

  return 'signInWithGoogle succeeded: $user';
}

Future<bool> updateProfile(
    {String userName,
    String email,
    String city,
    String bio,
    String profilePic}) async {
  try {
    var userId = FirebaseAuth.instance.currentUser.uid;
    print("userId:" + userId.toString());
    DocumentReference documentReferences =
        FirebaseFirestore.instance.collection("Users").doc(userId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReferences);
      if (!snapshot.exists) {
        documentReferences.set({
          'name': userName,
          'email': email,
          'city': city,
          'bio': bio,
          "profilePic": profilePic
        });
        return true;
      } else {
        transaction.update(documentReferences, {
          'name': userName,
          'email': email,
          'city': city,
          'bio': bio,
          "profilePic": profilePic
        });
        return true;
      }
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> addNewPost(
    {String userName,
    String title,
    String discription,
    double rating,
    String userId,
    List<String> imageList}) async {
  try {
    var userId = FirebaseAuth.instance.currentUser.uid;
    print("userId:" + userId.toString());
    DocumentReference documentReferences = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Posts")
        .doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      documentReferences.set({
        'name': userName,
        'title': title,
        'discription': discription,
        'rating': rating,
        'images': imageList,
        'userId': userId
      });
      return true;
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> addLocationToWishList(
    {String long, String lat, String title}) async {
  try {
    var userId = FirebaseAuth.instance.currentUser.uid;
    print("userId:" + userId.toString());
    DocumentReference documentReferences = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("WishList")
        .doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      documentReferences.set({
        'latValue': lat,
        'title': title,
        'longValue': long,
      });
      return true;
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> addLocationToAlreadyTravel(
    {String long, String lat, String title}) async {
  try {
    var userId = FirebaseAuth.instance.currentUser.uid;
    print("userId:" + userId.toString());
    DocumentReference documentReferences = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("WishList")
        .doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      documentReferences.set({
        'latValue': lat,
        'title': title,
        'longValue': long,
      });
      return true;
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

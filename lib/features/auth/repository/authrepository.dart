import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Models/user_model.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_clone/screens/mobilescreenlayou.dart';

final authrepositoryprovider = Provider(
  (ref) => authrepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class authrepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  authrepository({required this.auth, required this.firestore});

  Future<UserModel?> getcurrentuserdata() async {
    UserModel? user;
    var userdata =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userdata.data() != null) {
      user = UserModel.fromMap(userdata.data()!);
    }
    return user;
  }

  void signinwithphone(BuildContext context, String phonenumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: ((String verificationid, int? resendtoken) async {
          Navigator.pushNamed(
            context,
            OTPSCREEN.route,
            arguments: verificationid,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showsnackbar(context, e.toString());
    }
  }

  void verifyotp(
      {required BuildContext context,
      required String verificationid,
      required String userotp}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationid, smsCode: userotp);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserinformationScreen.routename, (route) => false);
    } on FirebaseAuthException catch (e) {
      showsnackbar(context, e.toString());
    }
  }

  void SaveUserDataToFirebase({
    required String name,
    required File? profilepic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photourl =
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60';

      if (profilepic != null) {
        photourl = await ref
            .read(commonfirebasestorageprovider)
            .StoreFileToFirebase('profilepic/$uid', profilepic);
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilepic: photourl,
        isOnline: true,
        phonenumber: auth.currentUser!.phoneNumber!,
        groupid: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MobileScreenLayout(),
          ),
          (route) => false);
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }

  Stream<UserModel> userdata(String userid) {
    return firestore.collection('users').doc(userid).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setuserstate(bool isonline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isonline,
    });
  }
}

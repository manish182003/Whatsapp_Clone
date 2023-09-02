import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Models/user_model.dart';
import 'package:whatsapp_clone/features/auth/repository/authrepository.dart';

final authcontrollerprovider = Provider((ref) {
  final authrepository = ref.watch(authrepositoryprovider);

  return AuthController(auth: authrepository, ref: ref);
});

final userproviderdata = FutureProvider((ref) {
  final AuthController = ref.watch(authcontrollerprovider);
  return AuthController.getuserdata();
});

class AuthController {
  final authrepository auth;
  final ProviderRef ref;

  AuthController({
    required this.auth,
    required this.ref,
  });

  void signinwithphone(BuildContext context, String phonenumber) {
    auth.signinwithphone(context, phonenumber);
  }

  void verifyotp(BuildContext context, String verificationid, String userotp) {
    auth.verifyotp(
      context: context,
      verificationid: verificationid,
      userotp: userotp,
    );
  }

  void saveuserdatatofirebase(
      BuildContext context, String name, File? profilepic) {
    auth.SaveUserDataToFirebase(
      name: name,
      profilepic: profilepic,
      ref: ref,
      context: context,
    );
  }

  Future<UserModel?> getuserdata() async {
    UserModel? user = await auth.getcurrentuserdata();
    return user;
  }

  Stream<UserModel> userdatabyid(String userid) {
    return auth.userdata(userid);
  }

  void setuserstate(bool isonline) async {
    auth.setuserstate(isonline);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Models/user_model.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final SelectContactRepositoryprovider = Provider(
  (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectcontact(Contact selectedcontact, BuildContext context) async {
    try {
      var usercollection = await firestore.collection('users').get();
      bool isfound = false;
      for (var document in usercollection.docs) {
        var userdata = UserModel.fromMap(document.data());
        String selectedphone =
            selectedcontact.phones[0].number.replaceAll(' ', '');

        if (selectedphone == userdata.phonenumber) {
          isfound = true;
          Navigator.pushNamed(
            context,
            MobileChatScreen.routename,
            arguments: {
              'name': userdata.name,
              'uid': userdata.uid,
            },
          );
        }
      }
      if (!isfound) {
        showsnackbar(context, 'This number does not exists on this app.');
      }
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }
}

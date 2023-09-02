import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/Models/chatcontact.dart';
import 'package:whatsapp_clone/Models/message.dart';
import 'package:whatsapp_clone/Models/user_model.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

final ChatRepositoryprovider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  void savedatatocontactsubcollection(
    UserModel senderuserdata,
    UserModel receiveruserdata,
    String text,
    DateTime timesent,
    String receiveruserid,
  ) async {
    var receiverchatcontact = ChatContact(
      name: senderuserdata.name,
      profilepic: senderuserdata.profilepic,
      contactid: senderuserdata.uid,
      timesent: timesent,
      lastmessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiveruserid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          receiverchatcontact.toMap(),
        );

    var senderchatcontact = ChatContact(
      name: receiveruserdata.name,
      profilepic: receiveruserdata.profilepic,
      contactid: receiveruserdata.uid,
      timesent: timesent,
      lastmessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiveruserid)
        .set(
          senderchatcontact.toMap(),
        );
  }

  Stream<List<ChatContact>> getchatcontacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contact = [];
      for (var document in event.docs) {
        var chatcontact = ChatContact.fromMap(document.data());
        var userdata = await firestore
            .collection('users')
            .doc(chatcontact.contactid)
            .get();
        var user = UserModel.fromMap(userdata.data()!);
        contact.add(ChatContact(
            name: user.name,
            profilepic: user.profilepic,
            contactid: chatcontact.contactid,
            timesent: chatcontact.timesent,
            lastmessage: chatcontact.lastmessage));
      }
      return contact;
    });
  }

  Stream<List<Message>> getchatstream(String receiveruserid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiveruserid)
        .collection('messages')
        .orderBy('timesent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(
          Message.fromMap(
            document.data(),
          ),
        );
      }
      return messages;
    });
  }

  void savemessagetomessagesubcollection({
    required String receiveruserid,
    required String text,
    required DateTime timesent,
    required String messageid,
    required String username,
    required String receiverusername,
    required MessageEnum messagetype,
  }) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiveruserid,
        text: text,
        type: messagetype,
        timesent: timesent,
        messageId: messageid,
        isSeen: false);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiveruserid)
        .collection('messages')
        .doc(messageid)
        .set(
          message.toMap(),
        );

    await firestore
        .collection('users')
        .doc(receiveruserid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageid)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserid,
    required UserModel senderuser,
  }) async {
    try {
      var timesent = DateTime.now();
      UserModel receiveruserdata;
      var userdatamap =
          await firestore.collection('users').doc(receiverUserid).get();
      receiveruserdata = UserModel.fromMap(userdatamap.data()!);
      var messageid = const Uuid().v1();
      savedatatocontactsubcollection(
          senderuser, receiveruserdata, text, timesent, receiverUserid);

      savemessagetomessagesubcollection(
        receiveruserid: receiverUserid,
        timesent: timesent,
        messagetype: MessageEnum.text,
        text: text,
        messageid: messageid,
        receiverusername: receiveruserdata.name,
        username: senderuser.name,
      );
    } catch (e) {
      showsnackbar(context, e.toString());
    }
  }
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonfirebasestorageprovider = Provider(
  (ref) => commonfirebasestorage(firebaseStorage: FirebaseStorage.instance),
);

class commonfirebasestorage {
  final FirebaseStorage firebaseStorage;

  commonfirebasestorage({required this.firebaseStorage});

  Future<String> StoreFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String Downloadurl = await snap.ref.getDownloadURL();
    return Downloadurl;
  }
}

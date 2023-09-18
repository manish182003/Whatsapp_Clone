import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserinformationScreen extends ConsumerStatefulWidget {
  static const String routename = '/user-info';
  

  @override
  ConsumerState<UserinformationScreen> createState() =>
      _UserinformationScreenState();
}

class _UserinformationScreenState extends ConsumerState<UserinformationScreen> {
  final TextEditingController namecontroller = TextEditingController();
  File? image;
  @override
  void dispose() {
    super.dispose();
    namecontroller.dispose();
  }

  void selectimage() async {
    image = await PickImageFromGallery(context);
    setState(() {});
  }

  void storeuserdata() async {
    String name = namecontroller.text.trim();
    if (name.isNotEmpty) {
      ref.read(authcontrollerprovider).saveuserdatatofirebase(
            context,
            name,
            image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        selectimage();
                      },
                      icon: Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: namecontroller,
                      decoration: InputDecoration(hintText: 'Enter your name'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      storeuserdata();
                    },
                    icon: Icon(Icons.done),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

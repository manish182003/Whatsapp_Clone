import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widget/error.dart';
import 'package:whatsapp_clone/common/widget/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/contacts/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routename = 'select-contact';
  const SelectContactScreen({super.key});

  void selectcontact(
      WidgetRef ref, Contact selectedcontact, BuildContext context) {
    ref
        .read(selectcontactcontrollerprovider)
        .selectcontact(selectedcontact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getcontactprovider).when(
        data: (contactlist) {
          return ListView.builder(
            itemCount: contactlist.length,
            itemBuilder: (context, index) {
              final contact = contactlist[index];
              return InkWell(
                onTap: () {
                  selectcontact(ref, contact, context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    leading: contact.photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 30,
                          ),
                    subtitle: Text(contact.phones[0].number),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return errorscreen(error: error.toString());
        },
        loading: () {
          return loader();
        },
      ),
    );
  }
}

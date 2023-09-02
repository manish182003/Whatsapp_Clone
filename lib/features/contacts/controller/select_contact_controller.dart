import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/contacts/repository/select_contact_repository.dart';

final getcontactprovider = FutureProvider((ref) {
  final selectrepostiory = ref.watch(SelectContactRepositoryprovider);
  return selectrepostiory.getContacts();
});

final selectcontactcontrollerprovider = Provider((ref) {
  final SelectContactRepository = ref.watch(SelectContactRepositoryprovider);
  return selectcontactcontroller(
    ref: ref,
    selectContactRepository: SelectContactRepository,
  );
});

class selectcontactcontroller {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  selectcontactcontroller({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectcontact(Contact selectedcontact, BuildContext context) {
    selectContactRepository.selectcontact(selectedcontact, context);
  }
}

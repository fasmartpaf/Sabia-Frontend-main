import 'package:contacts_service/contacts_service.dart' as contacts_service;
import 'package:sabia_app/model/contact_model.dart';
import 'package:sabia_app/utils/validate_field_util.dart';

abstract class ContactsService {
  Future<List<ContactModel>> getContacts();
}

class ContactsServiceImplementation extends ContactsService {
  @override
  Future<List<ContactModel>> getContacts() async {
    List<ContactModel> result = [];
    Iterable<contacts_service.Contact> contacts =
        await contacts_service.ContactsService.getContacts();

    contacts.forEach((contact) {
      if (contact.displayName != null &&
          contact.displayName.isNotEmpty &&
          contact.phones != null) {
        result.add(ContactModel(
          name: contact.displayName,
          emails: contact.emails
              .where((i) => isEmailValid(i.value))
              .map((e) => e.value)
              .toList(),
          phones: contact.phones
              .where((i) => i.value != null && i.value.length >= 8)
              .map((i) => i.value.replaceAll(RegExp(r"[^+0-9]+"), ""))
              .toList(),
        ));
      }
    });

    return result;
  }
}

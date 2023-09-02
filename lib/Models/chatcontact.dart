

class ChatContact {
  final String name;
  final String profilepic;
  final String contactid;
  final DateTime timesent;
  final String lastmessage;

  ChatContact(
      {required this.name,
      required this.profilepic,
      required this.contactid,
      required this.timesent,
      required this.lastmessage});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilepic': profilepic,
      'contactid': contactid,
      'timesent': timesent.millisecondsSinceEpoch,
      'lastmessage': lastmessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      profilepic: map['profilepic'] ?? '',
      contactid: map['contactid'] ?? '',
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent']),
      lastmessage: map['lastmessage'] ?? '',
    );
  }
}

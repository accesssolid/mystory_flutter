class Message {
  String? id = DateTime.now().toIso8601String();
  int? createdOnDate;
  String? messageText;
  String? messageMediaUrl;
  String? messageMediaType;
  String? senderId;

  Message();
}

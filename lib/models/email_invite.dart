class EmailInvite{
   String? to;
   Message? message;
   EmailInvite({this.to,this.message});
   EmailInvite.fromJson(Map<String, dynamic> json) {
     to = json['to'];
     message = json['message'];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['to'] = this.to;
     data['message'] = this.message;
     return data;
   }
}

class Message{
  String? subject;
  String? text;
  Message({this.subject,this.text});

  Message.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['text'] = this.text;
    return data;
  }
}
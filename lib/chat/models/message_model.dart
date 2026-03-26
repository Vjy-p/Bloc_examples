class Message {
  final String id;
  final String text;
  final bool isMe;

  Message({required this.id, required this.text, required this.isMe});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(id: json['id'], text: json['text'], isMe: json['isMe']);

  Map<String, dynamic> toJson() => {"id": id, "text": text, "isMe": isMe};
}

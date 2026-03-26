import 'dart:io';

enum ChatRole { user, model }

class ChatMessage {
  final String text;
  final File? image;
  final ChatRole role;

  ChatMessage({required this.text, this.image, required this.role});
}

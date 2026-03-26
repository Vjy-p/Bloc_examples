import 'dart:io';

abstract class ChatBotEvent {}

class SendMessageEvent extends ChatBotEvent {
  final String text;
  final File? image;
  SendMessageEvent(this.text, this.image);
}

class PickImageEvent extends ChatBotEvent {}

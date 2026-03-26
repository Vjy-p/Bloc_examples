import 'package:bloc_examples/chat/bloc/chat_bloc.dart';
import 'package:bloc_examples/chat/bloc/chat_event.dart';
import 'package:bloc_examples/chat/bloc/chat_state.dart';
import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/cuatom_button.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatInitialized());
    context.read<ChatBloc>().add(ChatHistoryRequested());
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageController.dispose();
    messageFocus.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTextSecondaryColor,
      appBar: AppBar(
        title: customText(
          text: "Chat",
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: kBlackColor,
        ),
        backgroundColor: kTextSecondaryColor,
        surfaceTintColor: kTextSecondaryColor,
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
            previous.chatList.length != current.chatList.length,
        listener: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToBottom();
          });
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state.status == ChatStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ChatStatus.failure) {
              return Center(
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(
                      text: "Something went wrong!",
                      fontSize: 18,
                      color: kTextColor,
                    ),
                    customButton(
                      onTap: () {
                        context.read<ChatBloc>().add(ChatInitialized());
                        context.read<ChatBloc>().add(ChatHistoryRequested());
                      },
                      text: "Retry",
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: state.chatList.length,
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return state.chatList[index].isMe
                            ? ownMessage(message: state.chatList[index].text)
                            : receivedMessage(
                                message: state.chatList[index].text,
                              );
                      },
                    ),
                  ),
                  textField(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget textField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: kWhiteColor),
          color: kWhiteColor,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                minLines: 1,
                maxLines: 100,
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kBlackColor,
                ),
                controller: messageController,
                decoration: InputDecoration(
                  hint: Text(
                    "enter message",
                    style: GoogleFonts.ubuntu(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kTextSecondaryColor,
                    ),
                  ),
                  filled: true,
                  fillColor: kWhiteColor,
                  enabled: true,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: IconButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (messageController.text.isNotEmpty) {
                    context.read<ChatBloc>().add(
                      ChatMessageSent(messageController.text),
                    );
                    messageController.clear();
                  }
                },
                icon: Icon(Icons.send, color: kButtonColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ownMessage({required String message}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: const Radius.circular(0),
                  bottomLeft: Radius.circular(12),
                ),
                color: kWhiteColor,
              ),
              child: customText(
                text: message,
                textAlign: TextAlign.left,
                color: kBlackColor.withValues(alpha: 0.9),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGreenAccentColor,
              ),
              padding: EdgeInsets.all(14),
              child: customText(text: "U", fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget receivedMessage({required String message}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGreenAccentColor,
              ),
              padding: EdgeInsets.all(14),
              child: customText(text: "O", fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(0),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                color: kWhiteColor,
              ),
              child: customText(
                text: message,
                textAlign: TextAlign.right,
                color: kBlackColor.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

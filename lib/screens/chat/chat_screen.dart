import 'package:activ_chat/models/chat_model.dart';
import 'package:activ_chat/models/group_model.dart';
import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/camera_provider.dart';
import 'package:activ_chat/providers/chat_provider.dart';
import 'package:activ_chat/providers/group_provider.dart';
import 'package:activ_chat/screens/chat/invite_screen.dart';
import 'package:activ_chat/screens/chat/text_detector_view.dart';
import 'package:activ_chat/screens/game/treasure_hunt/host_game_screen.dart';
import 'package:activ_chat/screens/game/treasure_hunt/object_detection_view.dart';
import 'package:activ_chat/utils/date_formatter.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.group, Key? key}) : super(key: key);

  final GroupModel group;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String messageText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).getChats(widget.group);
      Provider.of<CameraProvider>(context, listen: false).loadCameras();
    });
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupProvider>(context);
    final user = Provider.of<AuthProvider>(context);
    final chat = Provider.of<ChatProvider>(context);
    final camera = Provider.of<CameraProvider>(context);
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          OpenContainer(
            closedElevation: 0.0,
            closedColor: kPrimary,
            transitionDuration: const Duration(seconds: 1),
            transitionType: ContainerTransitionType.fade,
            openBuilder: (BuildContext context, VoidCallback _) {
              return InviteScreen(group: widget.group);
            },
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return const Icon(
                Icons.email_outlined,
                color: Colors.white,
              );
            },
          ),
          Container(
            width: 16.0,
          ),
          OpenContainer(
            closedElevation: 0.0,
            closedColor: kPrimary,
            transitionDuration: const Duration(seconds: 1),
            transitionType: ContainerTransitionType.fade,
            openBuilder: (BuildContext context, VoidCallback _) {
              return HostGameScreen(group: widget.group);
            },
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return const Icon(
                Icons.videogame_asset,
                color: Colors.white,
              );
            },
          ),
          Container(
            width: 16.0,
          )
        ],
        title: Text(
          widget.group.name ?? "",
          style: const TextStyle(
              fontSize: 20, fontFamily: 'Muli', fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      messageTextController.clear();
                      if (messageText.isNotEmpty) {
                        chat.createChat(
                          ChatModel(
                              group: widget.group.id,
                              fromId: user.user?.uid,
                              fromName: user.userInfo?.name,
                              message: messageText,
                              date: DateTime.now().toString(),
                              type: 'chat',
                              gameId: null),
                        );
                        group.updateGroup(
                            widget.group.copyWith(
                                lastMessage: messageText,
                                lastMessageDate: DateTime.now().toString(),
                                lastMessageSentBy: user.userInfo?.name),
                            widget.group.id ?? "");
                      }
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  OpenContainer(
                    closedElevation: 0.0,
                    closedColor: kPrimary,
                    onClosed: (data) {
                      if (data == true) {
                        messageTextController.text = camera.recognizedText;
                        messageText = camera.recognizedText;
                        camera.updateRecognizedText("");
                      }
                    },
                    transitionDuration: const Duration(seconds: 1),
                    transitionType: ContainerTransitionType.fade,
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return const TextDetectorView();
                    },
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    final chat = Provider.of<ChatProvider>(context);
    List<MessageBubble> messageBubbles = [];
    for (var message in chat.chats) {
      final messageText = message.message;
      final messageSender = message.fromName;

      final messageBubble = MessageBubble(
        sender: messageSender ?? "",
        date: message.date ?? DateTime.now().toString(),
        text: messageText ?? "",
        isMe: user.userInfo?.uid == message.fromId,
        type: message.type ?? 'chat',
        chat: message,
      );

      messageBubbles.add(messageBubble);
    }
    return Expanded(
      child: ListView(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: messageBubbles,
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.sender,
      required this.date,
      required this.text,
      required this.isMe,
      required this.type,
      required this.chat,
      Key? key})
      : super(key: key);

  final String sender;
  final String date;
  final String text;
  final bool isMe;
  final String type;
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                sender,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                DateFormatter()
                    .getVerboseDateTimeRepresentation(DateTime.parse(date)),
                style: const TextStyle(
                  fontSize: 9.0,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.orange : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: type == 'chat'
                  ? Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15.0,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ObjectDetectorView(chat: chat)));
                          },
                          child: const Text(
                            "Join game",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

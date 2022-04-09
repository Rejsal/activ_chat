import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/group_provider.dart';
import 'package:activ_chat/screens/chat/chat_screen.dart';
import 'package:activ_chat/screens/create_group_screen.dart';
import 'package:activ_chat/screens/notification_screen.dart';
import 'package:activ_chat/utils/date_formatter.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<GroupProvider>(context, listen: false).getGroups(
          Provider.of<AuthProvider>(context, listen: false).userInfo?.uid ??
              "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupProvider>(context);
    final user = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: kPrimary,
        floatingActionButton: OpenContainer(
          closedElevation: 0.0,
          closedColor: kPrimary,
          transitionDuration: const Duration(seconds: 1),
          transitionType: ContainerTransitionType.fade,
          openBuilder: (BuildContext context, VoidCallback _) {
            return const CreateGroupScreen();
          },
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25.0)),
              child: const Center(
                  child: Icon(
                Icons.add,
                color: Colors.white,
              )),
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Chats',
            style: TextStyle(
                fontSize: 20, fontFamily: 'Muli', fontWeight: FontWeight.w700),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, NotificationScreen.routeName);
              },
              child: const Icon(Icons.notifications),
            ),
            Container(
              width: 16.0,
            ),
            InkWell(
              onTap: () {
                user.signOut();
              },
              child: const Icon(Icons.logout),
            ),
            Container(
              width: 16.0,
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  fillColor: Colors.black,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                onChanged: (text) {
                  group.onSearchedGroup(text);
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              group.groups.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: group.groups.length,
                        itemBuilder: (_, index) {
                          final data = group.groups[index];
                          return OpenContainer(
                            closedElevation: 0.0,
                            closedColor: kPrimary,
                            transitionDuration: const Duration(seconds: 1),
                            transitionType: ContainerTransitionType.fade,
                            openBuilder:
                                (BuildContext context, VoidCallback _) {
                              return ChatScreen(
                                group: data,
                              );
                            },
                            closedBuilder: (BuildContext context,
                                VoidCallback openContainer) {
                              return Card(
                                elevation: 4.0,
                                clipBehavior: Clip.antiAlias,
                                color: Colors.black,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "${data.name}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      trailing: Text(
                                        data.lastMessageDate != null
                                            ? DateFormatter()
                                                .getVerboseDateTimeRepresentation(
                                                    DateTime.parse(
                                                        data.lastMessageDate ??
                                                            ""))
                                            : "",
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      subtitle: Text(
                                        data.lastMessageSentBy != null &&
                                                data.lastMessage != null
                                            ? '${data.lastMessageSentBy}: ${data.lastMessage}'
                                            : "No messages",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  : const Expanded(
                      child: Center(
                        child: Text(
                          'No Groups to show',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}

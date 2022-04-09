import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/group_provider.dart';
import 'package:activ_chat/providers/notification_provider.dart';
import 'package:activ_chat/utils/date_formatter.dart';
import 'package:activ_chat/utils/dialogs.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notification';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .getNotifications(
              Provider.of<AuthProvider>(context, listen: false).userInfo?.uid ??
                  "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupProvider>(context);
    final user = Provider.of<AuthProvider>(context);
    final notification = Provider.of<NotificationProvider>(context);
    return Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Notifications',
            style: TextStyle(
                fontSize: 20, fontFamily: 'Muli', fontWeight: FontWeight.w700),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: notification.notifications.isNotEmpty
              ? ListView.builder(
                  itemCount: notification.notifications.length,
                  itemBuilder: (_, index) {
                    final data = notification.notifications[index];
                    return GestureDetector(
                      onTap: () async {
                        var dialog = await Dialogs.confirmDialog(
                            context,
                            "Accept invitation",
                            "Please confirm whether you like to join",
                            "Yes",
                            "No");
                        if (dialog == ConfirmAction.accept) {
                          if (data.type == 'chat') {
                            var groupInfo =
                                await group.getGroupById(data.group ?? "");
                            List<String> users = groupInfo.users ?? [];
                            users.add(user.userInfo?.id ?? "");
                            group.updateGroup(groupInfo.copyWith(users: users),
                                data.group ?? "");
                            notification.updateNotification(
                                data.copyWith(status: 'completed'),
                                data.id ?? "");
                          }
                        }
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                "${data.message}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Text(
                                data.createdAt != null
                                    ? DateFormatter()
                                        .getVerboseDateTimeRepresentation(
                                            DateTime.parse(
                                                data.createdAt ?? ""))
                                    : "",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                data.fromName != null
                                    ? "Sent by: ${data.fromName}"
                                    : "",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No Notifications to show',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ));
  }
}

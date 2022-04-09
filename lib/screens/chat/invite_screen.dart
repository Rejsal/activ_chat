import 'package:activ_chat/components/common_button.dart';
import 'package:activ_chat/models/group_model.dart';
import 'package:activ_chat/models/notification_model.dart';
import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/notification_provider.dart';
import 'package:activ_chat/utils/dialogs.dart';
import 'package:activ_chat/utils/helper.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({required this.group, Key? key}) : super(key: key);
  final GroupModel group;

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  String email = "";
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final notification = Provider.of<NotificationProvider>(context);
    final user = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: kPrimary,
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Invite to: ${widget.group.name ?? ""}',
          style: const TextStyle(
              fontSize: 20, fontFamily: 'Muli', fontWeight: FontWeight.w700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 40.0,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                validator: (value) => (value!.isEmpty)
                    ? 'Email is required'
                    : !Helper.isValidEmail(value)
                        ? 'Invalid Email'
                        : null,
                style: const TextStyle(color: Colors.white),
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Email Address'),
              ),
              const SizedBox(
                height: 25.0,
              ),
              notification.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : CommonButton(
                      title: 'Invite',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          var toUser =
                              await user.getUserDetailFromEmail(email.trim());
                          if (toUser != null) {
                            if (widget.group.users?.contains(toUser.uid) ==
                                true) {
                              await Dialogs.infoDialogWithoutTitle(
                                  context, 'Already in group!', 'Ok');
                            } else {
                              if (await notification.createNotification(
                                NotificationModel(
                                    fromName: user.userInfo?.name,
                                    createdAt: DateTime.now().toString(),
                                    from: user.userInfo?.uid,
                                    to: toUser.uid,
                                    group: widget.group.id,
                                    status: 'pending',
                                    message:
                                        'You have been invited to: ${widget.group.name}',
                                    type: "chat",
                                    gameId: null),
                              )) {
                                await Dialogs.infoDialogWithoutTitle(
                                    context, 'Invited!', 'Ok');
                                Navigator.pop(context);
                              } else {
                                await Dialogs.infoDialogWithoutTitle(context,
                                    'Unexpected error occurred!', 'Ok');
                              }
                            }
                          } else {
                            await Dialogs.infoDialogWithoutTitle(
                                context, 'User not found!', 'Ok');
                          }
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

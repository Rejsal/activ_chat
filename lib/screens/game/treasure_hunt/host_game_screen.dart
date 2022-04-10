import 'package:activ_chat/components/common_button.dart';
import 'package:activ_chat/models/chat_model.dart';
import 'package:activ_chat/models/group_model.dart';
import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/chat_provider.dart';
import 'package:activ_chat/utils/dialogs.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostGameScreen extends StatefulWidget {
  const HostGameScreen({required this.group, Key? key}) : super(key: key);
  final GroupModel group;

  @override
  _HostGameScreenState createState() => _HostGameScreenState();
}

class _HostGameScreenState extends State<HostGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  String category = "";
  String message = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    final chat = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: kPrimary,
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Host game',
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
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  category = value;
                },
                validator: (value) =>
                    (value!.isEmpty) ? 'Category is required' : null,
                style: const TextStyle(color: Colors.white),
                decoration: kTextFieldDecoration.copyWith(hintText: 'Category'),
              ),
              const Text(
                "This is a concept. We can be more specific in future.",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  message = value;
                },
                validator: (value) =>
                    (value!.isEmpty) ? 'Treasure clue is required' : null,
                style: const TextStyle(color: Colors.white),
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Treasure clue'),
              ),
              const SizedBox(
                height: 25.0,
              ),
              chat.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : CommonButton(
                      title: 'Create',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (await chat.createChat(ChatModel(
                            group: widget.group.id,
                            fromId: user.userInfo?.uid,
                            fromName: user.userInfo?.name,
                            message: message,
                            category: category,
                            type: 'game',
                            date: DateTime.now().toString(),
                          ))) {
                            await Dialogs.infoDialogWithoutTitle(
                                context, 'New game hosted!', 'Ok');
                            Navigator.pop(context);
                          } else {
                            await Dialogs.infoDialogWithoutTitle(
                                context, 'Unexpected error occurred!', 'Ok');
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

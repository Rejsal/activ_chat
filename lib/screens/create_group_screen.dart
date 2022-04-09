import 'package:activ_chat/components/common_button.dart';
import 'package:activ_chat/models/group_model.dart';
import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/group_provider.dart';
import 'package:activ_chat/utils/dialogs.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String groupName = "";
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupProvider>(context);
    final user = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: kPrimary,
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Create group',
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
                  groupName = value;
                },
                validator: (value) =>
                    (value!.isEmpty) ? 'Group name is required' : null,
                style: const TextStyle(color: Colors.white),
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Group name'),
              ),
              const SizedBox(
                height: 25.0,
              ),
              group.loading
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
                          if (await group.createGroup(GroupModel(
                              name: groupName,
                              users: [user.userInfo?.uid ?? ""],
                              createdAt: DateTime.now().toString()))) {
                            await Dialogs.infoDialogWithoutTitle(
                                context, 'New group created!', 'Ok');
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

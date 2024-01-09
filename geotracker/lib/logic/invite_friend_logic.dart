import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:geotracker/utils/my_info.dart';
import 'package:geotracker/http/invite_accept.dart';

import '../utils/styles.dart';

class InviteFriend {
  static final formKey = GlobalKey<FormState>();
  static late String _login;

  static inviteFriend(BuildContext context) async {
    var log = Logger();
    log.d("Friend name: $_login");
    var inviteResult = await InviteAcceptRestApi().invite(MyInfo.token, _login);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An invitation to be friends has been sent')),
    );
    if (inviteResult.error != null) {
      log.d("Invite error: ${inviteResult.error}");
    }
  }

  Widget inviteFriendView(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding (
            padding: const EdgeInsets.only(top: 25.0),
            child: SizedBox(
              width: 280,
              height: 55,
              child: TextFormField(
                onChanged: (name) => _login = name,
                decoration: Style().textFormFieldDecoration(context, "Friend\'s login"),
                keyboardType: TextInputType.text,
                autocorrect: false,
                enableSuggestions: false,
                style: Style().textFormFieldTextStyle(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter friend login';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  inviteFriend(context);
                }
              },
              style: Style().elevatedButtonStyle(),
              child: const Text('Send request'),
            ),
          ),
        ]
      ),
    );
  }
}
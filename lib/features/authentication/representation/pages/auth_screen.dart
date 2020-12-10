import 'package:fc_twitter/core/util/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'auth_form.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Icon(
          FontAwesome.twitter,
          color: Theme.of(context).primaryColor,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Text(
              'See what\'s happening in the world right now.',
              style: TextStyle(
                fontSize: Config.xMargin(context, 8),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Config.yMargin(context, 2)),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AuthForm.pageId,
                  arguments: false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Create account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Config.xMargin(context, 6),
                      color: Colors.white),
                ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  'Have an account already?',
                  style: TextStyle(fontSize: Config.xMargin(context, 4)),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AuthForm.pageId,
                      arguments: true),
                  child: Text(
                    ' Log in',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Config.xMargin(context, 4)
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

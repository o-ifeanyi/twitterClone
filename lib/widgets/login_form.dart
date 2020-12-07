import 'package:fc_twitter/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_twitter/util/config.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final _formKey;
  LoginForm(this._formKey);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log in to Twitter.',
            style: TextStyle(
              fontSize: Config.xMargin(context, 6),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Config.yMargin(context, 2)),
          TextFormField(
            controller: _loginEmailController,
            decoration: InputDecoration(
              labelText: 'Phone or email',
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Feild cannot be empty';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _loginPasswordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: (val) {
              if (val.isEmpty) {
                return 'Feild cannot be empty';
              }
              return null;
            },
          ),
          SizedBox(height: Config.yMargin(context, 2)),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Forgot password?',
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Divider(
            thickness: 1,
            height: 25,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                bool isValid = widget._formKey.currentState.validate();
                if (!isValid) return;
                FocusScope.of(context).unfocus();
                context.read<AuthBloc>().add(Login(
                      email: _loginEmailController.text,
                      password: _loginPasswordController.text,
                    ));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Log in',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Config.xMargin(context, 4),
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}